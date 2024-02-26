//
//  VocaTranslatedVM.swift
//  VocaWeaveApp
//
//  Created by 천광조 on 12/8/23.
//

import Combine
import RealmSwift
import UIKit
import SnapKit

final class VocaTranslatedVM {
    // MARK: - Property
    private let datamanager: RealmTranslateType
    let tableViewUpdate = PassthroughSubject<[RealmTranslateModel], Never>()
    let alertPublisher = PassthroughSubject<UIAlertController, Never>()
    let errorAlertPublisher = PassthroughSubject<UIAlertController, Never>()
    let whitespacesAlertPublisher = PassthroughSubject<UIAlertController, Never>()
    let duplicationAlertPublisher = PassthroughSubject<UIAlertController, Never>()
    private let networking = NetworkingManager.shared
    var vocaList: [RealmTranslateModel] {
        return datamanager.getVocaList()
    }
    // MARK: - init
    init(datamanager: RealmTranslateType) {
        self.datamanager = datamanager
    }
    // MARK: - Helper
    func manageEmptyView(vocaVC: UIViewController,
                         emptyView: EmptyListView,
                         tableView: UITableView) {
        if vocaList.isEmpty {
            tableView.isHidden = true
            vocaVC.view.addSubview(emptyView)
            emptyView.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.centerY.equalToSuperview()
            }
        } else {
            emptyView.removeFromSuperview()
            tableView.isHidden = false
        }
    }

    func isVocaAlreadyExists(_ voca: RealmTranslateModel) -> Bool {
          let existingVocaList: [RealmTranslateModel] = vocaList
          return existingVocaList.contains { $0.sourceText == voca.sourceText
                                          && $0.translatedText == voca.translatedText }
      }
    // MARK: - Action
    func addVoca(_ list: RealmTranslateModel) {
        datamanager.makeNewList(list)
    }

    func updateVoca(list: RealmTranslateModel, text: String, isSelected: Bool) {
        datamanager.updateListInfo(list: list, text: text, isSelected: isSelected)
    }

    func deleteVoca(_ list: RealmTranslateModel) {
        datamanager.deleteList(list)
    }

    @MainActor
    func editDictionaryData(currentView: VocaVC, vocaData: RealmTranslateModel) {
        let dicVM = DictionaryVM(vocaTranslatedVM: self,
                                 vocaTranslatedData: vocaData,
                                 dictionaryEnum: .edit)
        let dictionaryView =  DictionaryVC(dictionaryVM: dicVM)
        self.goToNextPage(currentView: currentView,
                        nextView: dictionaryView)
    }
}
// MARK: - Private
private extension VocaTranslatedVM {
    func removeLeadingAndTrailingSpaces(from string: String) -> String {
        var modifiedString = string
        while modifiedString.hasPrefix(" ") {
            modifiedString.removeFirst()
        }
        while modifiedString.hasSuffix(" ") {
            modifiedString.removeLast()
        }
        return modifiedString
    }

    func fetchDataAndHandleResult(sourceText: String) async throws -> TranslateReponseModel? {
        if Language.detectLanguage(text: sourceText) {
            do {
                let result = try await networking.fetchData(source: Language.sourceLanguage.languageCode,
                                                            target: Language.targetLanguage.languageCode,
                                                            text: sourceText)
                return result
            } catch {
                print("에러 발생: \(error)")
                throw error
            }
        } else {
            errorResponseAlert()
            return nil
        }
    }

    @MainActor
    func goToNextPage(currentView: VocaVC,
                      nextView: DictionaryVC) {
        let navigationController = UINavigationController(rootViewController: nextView)
        navigationController.modalPresentationStyle = .fullScreen
        currentView.present(navigationController, animated: false)
    }

    func dictionaryUpdateVoca(list: RealmTranslateModel, text: String, isSelected: Bool) {
        datamanager.updateListInfo(list: list, text: text, isSelected: isSelected)
        let newVocaList: [RealmTranslateModel] = vocaList
        self.tableViewUpdate.send(newVocaList)
    }

    @MainActor
    private func checkForExistingData(with text: String) -> RealmTranslateModel? {
        let translatedData = vocaList
        if let duplicatedData = translatedData.first(where: { $0.sourceText == text }) {
            return duplicatedData
        }
        return nil
    }

    func fetchDictionaryData(sourceText: String, currentView: VocaVC) {
        Task {
            do {
                guard let responseData = try await self.fetchDataAndHandleResult(sourceText: sourceText)
                else { return }
                let voca = RealmTranslateModel(apiModel: responseData, sourceText: sourceText)
                let dicVM = DictionaryVM(vocaTranslatedVM: self,
                                         vocaTranslatedData: voca,
                                         dictionaryEnum: .response)
                let dictionaryView = await DictionaryVC(dictionaryVM: dicVM)
                await self.goToNextPage(currentView: currentView,
                                      nextView: dictionaryView)
            } catch {
                print("Task Response : \(error)")
            }
        }
    }
}
// MARK: - Alert - Add, Update Method
extension VocaTranslatedVM {
    func showAlertWithTextField(currentView: VocaVC) {
        let alert = configureAlert(currentView: currentView)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cancelAction)
        alertPublisher.send(alert)
    }

    private func configureAlert(currentView: VocaVC) -> UIAlertController {
        let alert = UIAlertController(title: "검색할 단어를 입력해 주세요.",
                                      message: nil,
                                      preferredStyle: .alert)
        addPlaceholders(to: alert)
        addAlertAction(for: alert, currentView: currentView)
        return alert
    }

    private func addPlaceholders(to alert: UIAlertController) {
        alert.addTextField { textField in textField.placeholder = "단어를 입력해 주세요." }
    }

    private func addAlertAction(for alert: UIAlertController, currentView: VocaVC) {
        let searchAction = UIAlertAction(title: "Search", style: .default) { [weak self, weak alert] _ in
            guard let self = self,
                  let alert = alert,
                  let sourcetextField = alert.textFields?[0],
                  var sourcetext = sourcetextField.text else { return }
            sourcetext = self.removeLeadingAndTrailingSpaces(from: sourcetext)

            if sourcetext.isEmpty {
                self.showEmptyTextFieldAlert()
                return
            } else if let vocaData = vocaList.first(where: { $0.sourceText == sourcetext }) {
                DispatchQueue.main.async {
                    self.editDictionaryData(currentView: currentView, vocaData: vocaData)
                }
            }
            fetchDictionaryData(sourceText: sourcetext, currentView: currentView)
        }
        alert.addAction(searchAction)
    }

    private func errorResponseAlert() {
        let alert = UIAlertController(title: "오류!!",
                                      message: "영어 또는 한글의 언어를 입력해 주세요!",
                                      preferredStyle: .alert)
        let cancel = UIAlertAction(title: "cancel", style: .cancel)
        alert.addAction(cancel)
        errorAlertPublisher.send(alert)
    }

    private func showEmptyTextFieldAlert() {
        let alert = UIAlertController(title: "경고", message: "단어가 비어 있습니다.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        whitespacesAlertPublisher.send(alert)
    }

    func setBookmarkStatus(isSelec: Bool, bookmarkButton: UIButton) {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 20)
        if isSelec {
            bookmarkButton.setImage(UIImage(systemName: "star.fill",
                                    withConfiguration: imageConfig),
                                    for: .normal)
        } else {
            bookmarkButton.setImage(UIImage(systemName: "star",
                                    withConfiguration: imageConfig),
                                    for: .normal)
        }
    }
}
