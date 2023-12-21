//
//  VocaViewModel.swift
//  VocaWeaveApp
//
//  Created by 천광조 on 12/8/23.
//

import Combine
import RealmSwift
import UIKit

class VocaTranslatedViewModel {
    // MARK: - Property
    let datamanager: RealmTranslateType
    let tableViewUpdate = PassthroughSubject<[RealmTranslateModel], Never>()
    let alertPublisher = PassthroughSubject<UIAlertController, Never>()
    let errorAlertPublisher = PassthroughSubject<UIAlertController, Never>()
    let whitespacesAlertPublisher = PassthroughSubject<UIAlertController, Never>()
    let networking = NetworkingManager.shared
    var sourceLanguage: Language = .korean
    var targetLanguage: Language = .english

    // MARK: - init
    init(datamanager: RealmTranslateType) {
        self.datamanager = datamanager
    }

    // MARK: - Helper
    func getVocaList() -> [RealmTranslateModel] {
        return datamanager.getVocaList()
    }

    func addVoca(_ list: RealmTranslateModel) {
        datamanager.makeNewList(list)
    }

    func updateVoca(list: RealmTranslateModel, text: String, isSelected: Bool) {
        datamanager.updateListInfo(list: list, text: text, isSelected: isSelected)
    }

    func deleteVoca(_ list: RealmTranslateModel) {
        datamanager.deleteList(list)
    }
    // MARK: - Action
    private func fetchDataAndHandleResult(sourceText: String) async throws -> TranslateReponseModel? {
        if detectLanguage(text: sourceText) {
            do {
                let result = try await networking.fetchData(source: sourceLanguage.languageCode,
                                                            target: targetLanguage.languageCode,
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

    private func detectLanguage(text: String) -> Bool {
        if text.containsOnlyKorean() {
            sourceLanguage = .korean
            targetLanguage = .english
            return true
        } else if text.containsOnlyEnglish() {
            sourceLanguage = .english
            targetLanguage = .korean
           return true
        }
        return false
    }

    private func nextGoPage(currentView: VocaViewController,
                            nextView: UINavigationController) {
        DispatchQueue.main.async {
            nextView.modalPresentationStyle = .fullScreen
            currentView.present(nextView, animated: true)
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

}
// MARK: - Alert - Add, Update Method
extension VocaTranslatedViewModel {
    func showAlertWithTextField(currentView: VocaViewController) {
        let alert = configureAlert(currentView: currentView)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cancelAction)
        alertPublisher.send(alert)
    }

    private func configureAlert(currentView: VocaViewController) -> UIAlertController {
        let alert = UIAlertController(title: "검색할 단어를 입력해 주세요.", message: nil, preferredStyle: .alert)
            addPlaceholders(to: alert)
        addAction(for: alert, currentView: currentView)
        return alert
    }

    private func addPlaceholders(to alert: UIAlertController) {
        alert.addTextField { textField in
            textField.placeholder = "단어를 입력해 주세요."
        }
    }

    private func addAction(for alert: UIAlertController, currentView: VocaViewController) {
        let searchAction = UIAlertAction(title: "Search", style: .default) { [weak self, weak alert] _ in
            guard let self = self,
                  let alert = alert,
                  let sourcetextField = alert.textFields?[0],
                  var sourcetext = sourcetextField.text else { return }
            sourcetext = self.removeLeadingAndTrailingSpaces(from: sourcetext)

            if sourcetext.isEmpty {
                self.showEmptyTextFieldAlert()
                return
            }
            fetchDictionaryData(sourceText: sourcetext, currentView: currentView)
        }
        alert.addAction(searchAction)
    }

    func fetchDictionaryData(sourceText: String, currentView: VocaViewController) {
        Task {
            do {
                guard let responseData = try await self.fetchDataAndHandleResult(sourceText: sourceText)
                else { return }
                let voca = RealmTranslateModel(apiModel: responseData, sourceText: sourceText)
                let dictionaryView = await UINavigationController(
                    rootViewController: DictionaryViewController(
                                                                vocaTranslatedData: voca,
                                                                dictionaryEnum: .response,
                                                                vocaTranslatedViewModel: self))
                self.nextGoPage(currentView: currentView, nextView: dictionaryView)
            } catch {
                print("Task Response error")
            }
        }
    }

    func saveDictionaryData(_ voca: RealmTranslateModel) {
        if !self.isVocaAlreadyExists(voca) {
            self.addVoca(voca)
            let newVocaList: [RealmTranslateModel] = self.getVocaList()
            self.tableViewUpdate.send(newVocaList)
        } else {
            print("이미 존재하는 데이터입니다.")
        }
    }

  private func isVocaAlreadyExists(_ voca: RealmTranslateModel) -> Bool {
        let existingVocaList: [RealmTranslateModel] = getVocaList()
        return existingVocaList.contains { $0.sourceText == voca.sourceText
                                        && $0.translatedText == voca.translatedText }
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
}
