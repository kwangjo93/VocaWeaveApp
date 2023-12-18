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
    let datamanager: RealmTranslateType
    let tableViewUpdate = PassthroughSubject<[RealmTranslateModel], Never>()
    let alertPublisher = PassthroughSubject<UIAlertController, Never>()
    let networking = NetworkingManager.shared
    var sourceLanguage: Language = .korean
    var targetLanguage: Language = .english

    init(datamanager: RealmTranslateType) {
        self.datamanager = datamanager
    }

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

    private func fetchDataAndHandleResult(sourceText: String) async throws -> TranslateReponseModel {
        detectLanguage(text: sourceText)
        do {
            let result = try await networking.fetchData(source: sourceLanguage.languageCode,
                                                        target: targetLanguage.languageCode,
                                                        text: sourceText)
            return result
        } catch {
            print("에러 발생: \(error)")
            throw error
        }
    }

    private func detectLanguage(text: String) {
        if text.containsOnlyKorean() {
            sourceLanguage = .korean
            targetLanguage = .english
        } else if text.containsOnlyEnglish() {
            sourceLanguage = .english
            targetLanguage = .korean
        }
    }

    func toggleHeaderVisibility(sectionTitle: String, headerView: VocaTableViewHeaderView) {
        let itemsInSection = getVocaList().filter { $0.section == sectionTitle }
        headerView.isHidden = itemsInSection.isEmpty
        if let tableView = headerView.superview as? UITableView {
            tableView.reloadData()
        }
    }

    private func nextGoPage(currentView: VocaViewController,
                            nextView: UINavigationController) {
        DispatchQueue.main.async {
            nextView.modalPresentationStyle = .fullScreen
            currentView.present(nextView, animated: true)
        }
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
                  let sourcetext = sourcetextField.text else { return }
            fetchDictionaryData(sourceText: sourcetext, currentView: currentView)
        }
        alert.addAction(searchAction)
    }

    func fetchDictionaryData(sourceText: String, currentView: VocaViewController) {
        Task {
            do {
                let responseData = try await self.fetchDataAndHandleResult(sourceText: sourceText)
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

  private  func isVocaAlreadyExists(_ voca: RealmTranslateModel) -> Bool {
        let existingVocaList: [RealmTranslateModel] = getVocaList()
        return existingVocaList.contains { $0.sourceText == voca.sourceText
                                        && $0.translatedText == voca.translatedText }
    }
}
