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
import Lottie

final class VocaTranslatedVM {
    // MARK: - Property
    let datamanager: RealmTranslateType
    let tableViewUpdate = PassthroughSubject<[RealmTranslateModel], Never>()
    let alertPublisher = PassthroughSubject<UIAlertController, Never>()
    let errorAlertPublisher = PassthroughSubject<UIAlertController, Never>()
    let whitespacesAlertPublisher = PassthroughSubject<UIAlertController, Never>()
    let duplicationAlertPublisher = PassthroughSubject<UIAlertController, Never>()
    let networking = NetworkingManager.shared
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

    private func removeLeadingAndTrailingSpaces(from string: String) -> String {
        var modifiedString = string
        while modifiedString.hasPrefix(" ") {
            modifiedString.removeFirst()
        }
        while modifiedString.hasSuffix(" ") {
            modifiedString.removeLast()
        }
        return modifiedString
    }

    private func isVocaAlreadyExists(_ voca: RealmTranslateModel) -> Bool {
          let existingVocaList: [RealmTranslateModel] = vocaList
          return existingVocaList.contains { $0.sourceText == voca.sourceText
                                          && $0.translatedText == voca.translatedText }
      }

    func setupCell(cell: VocaTableViewCell,
                   sourceText: String,
                   translatedText: String,
                   isSelected: Bool,
                   selectedSegmentIndex: Int) {
        cell.sourceLabel.text = sourceText
        cell.translatedLabel.text = translatedText
        cell.isSelect = isSelected
        cell.selectedSegmentIndex = selectedSegmentIndex
        cell.configureBookmark()
        cell.selectionStyle = .none
    }
    // MARK: - Action
    func addVoca(_ list: RealmTranslateModel) {
        datamanager.makeNewList(list)
    }

    func updateVoca(list: RealmTranslateModel, text: String, isSelected: Bool) {
        datamanager.updateListInfo(list: list, text: text, isSelected: isSelected)
    }

    private func dictionaryUpdateVoca(list: RealmTranslateModel, text: String, isSelected: Bool) {
        datamanager.updateListInfo(list: list, text: text, isSelected: isSelected)
        let newVocaList: [RealmTranslateModel] = vocaList
        self.tableViewUpdate.send(newVocaList)
    }

    func deleteVoca(_ list: RealmTranslateModel) {
        datamanager.deleteList(list)
    }

    private func fetchDataAndHandleResult(sourceText: String) async throws -> TranslateReponseModel? {
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
    private func nextGoPage(currentView: VocaVC,
                            nextView: DictionaryVC) {
        let navigationController = UINavigationController(rootViewController: nextView)
        navigationController.modalPresentationStyle = .fullScreen
        currentView.present(navigationController, animated: true)
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
// MARK: - Dictionary Method
extension VocaTranslatedVM {
    func fetchDictionaryData(sourceText: String, currentView: VocaVC) {
        Task {
            do {
                guard let responseData = try await self.fetchDataAndHandleResult(sourceText: sourceText)
                else { return }
                let voca = RealmTranslateModel(apiModel: responseData, sourceText: sourceText)
                let dictionaryView = await DictionaryVC(vocaTranslatedData: voca,
                                                        dictionaryEnum: .response,
                                                        vocaTranslatedVM: self,
                                                        dictionaryVM: nil)
                await self.nextGoPage(currentView: currentView,
                                      nextView: dictionaryView)
            } catch {
                print("Task Response : \(error)")
            }
        }
    }

    @MainActor
    private func checkForExistingData(with text: String) -> RealmTranslateModel? {
        let translatedData = vocaList
        if let duplicatedData = translatedData.first(where: { $0.sourceText == text }) {
            return duplicatedData
        }
        return nil
    }

    @MainActor
    private func checkDuplicationData(vocaData: RealmTranslateModel, text: String) -> RealmTranslateModel {
        if vocaData.sourceText == text {
            if let duplicatedData = checkForExistingData(with: text) {
                return duplicatedData
            }
        }
        return vocaData
    }

    func fetchDicDataResult(sourceText: String) async throws -> RealmTranslateModel? {
        if Language.detectLanguage(text: sourceText) {
            do {
                let responseData = try await networking.fetchData(source: Language.sourceLanguage.languageCode,
                                                                  target: Language.targetLanguage.languageCode,
                                                                  text: sourceText)
                let result = RealmTranslateModel(apiModel: responseData, sourceText: sourceText)
                let vocaData = await checkDuplicationData(vocaData: result, text: sourceText)
                return vocaData
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
    func editDictionaryData(currentView: VocaVC, vocaData: RealmTranslateModel) {
        let dictionaryView =  DictionaryVC(vocaTranslatedData: vocaData,
                                           dictionaryEnum: .edit,
                                           vocaTranslatedVM: self,
                                           dictionaryVM: nil)
        self.nextGoPage(currentView: currentView,
                        nextView: dictionaryView)
    }

    func saveDictionaryData(_ voca: RealmTranslateModel, vocaTranslatedVM: VocaTranslatedVM?) {
        if !self.isVocaAlreadyExists(voca) {
            self.addVoca(voca)
            let newVocaList: [RealmTranslateModel] = self.vocaList
            self.tableViewUpdate.send(newVocaList)
        } else {
            guard vocaTranslatedVM != nil else { return }
            let alert = UIAlertController(title: "중복",
                                          message: "같은 단어가 이미 있습니다",
                                          preferredStyle: .alert)
               DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                   alert.dismiss(animated: true, completion: nil)
               }
            duplicationAlertPublisher.send(alert)
        }
    }

    @MainActor
    func updateTranslationView(with vocaData: RealmTranslateModel?,
                               view: DictionaryView) {
        guard let vocaData = vocaData else { return }
        view.translationText.text = vocaData.translatedText
        self.setBookmarkStatus(isSelec: vocaData.isSelected, bookmarkButton: view.bookmarkButton)
    }

    private func setupAnimationView(button: UIButton, animationView view: LottieAnimationView) {
        button.addSubview(view)
        let animation = LottieAnimation.named("starfill")
        view.animation = animation
        view.contentMode = .scaleAspectFit
        view.loopMode = .playOnce
        view.isHidden = true
        view.frame = CGRect(x: -37, y: -37, width: 100, height: 100)
    }

    func playAnimation(view: DictionaryView, isSelect: Bool, text: String) {
        let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedText.isEmpty else { return }
        if isSelect {
            setupAnimationView(button: view.bookmarkButton,
                               animationView: view.animationView)
            view.animationView.isHidden = false
            view.animationView.play { _ in
                view.animationView.isHidden = true
            }
        }
    }

    @MainActor
    func bookmarkButtonAction(vocaData: RealmTranslateModel,
                              text: String,
                              bookmarkButton: UIButton,
                              view: DictionaryView) {
        let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedText.isEmpty else { return }
        if checkForExistingData(with: text) == nil {
            saveDictionaryData(vocaData, vocaTranslatedVM: nil)
            updateVoca(list: vocaData, text: vocaData.translatedText, isSelected: true)
        } else {
            switch vocaData.isSelected {
            case true:
                dictionaryUpdateVoca(list: vocaData, text: vocaData.translatedText, isSelected: false)
            case false:
                dictionaryUpdateVoca(list: vocaData, text: vocaData.translatedText, isSelected: true)
            }
        }
        setBookmarkStatus(isSelec: vocaData.isSelected, bookmarkButton: bookmarkButton)
        playAnimation(view: view, isSelect: vocaData.isSelected, text: vocaData.sourceText)
    }

}
