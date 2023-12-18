//
//  vocaListViewModel.swift
//  VocaWeaveApp
//
//  Created by 천광조 on 12/14/23.
//

import UIKit
import Combine

final class VocaListViewModel {
    // MARK: - Property
    let datamanager: RealmVocaModelType
    let alertPublisher = PassthroughSubject<UIAlertController, Never>()
    let tableViewUpdate = PassthroughSubject<[RealmVocaModel], Never>()
    // MARK: - init
    init(datamanager: RealmVocaModelType) {
        self.datamanager = datamanager
    }
    // MARK: - Logic
    func getVocaList() -> [RealmVocaModel] {
        return datamanager.getVocaList()
    }

    private func addVoca(_ list: RealmVocaModel) {
        datamanager.makeNewList(list)
    }

    func updateVoca(list: RealmVocaModel, sourceText: String, translatedText: String, isSelected: Bool) {
        datamanager.updateListInfo(list: list,
                                   sourceText: sourceText,
                                   translatedText: translatedText,
                                   isSelected: isSelected)
    }

    func deleteVoca(_ list: RealmVocaModel) {
        datamanager.deleteList(list)
    }

    func toggleHeaderVisibility(sectionTitle: String, headerView: VocaTableViewHeaderView) {
        let itemsInSection = getVocaList().filter { $0.section == sectionTitle }
        headerView.isHidden = itemsInSection.isEmpty
        if let tableView = headerView.superview as? UITableView {
            tableView.reloadData()
        }
    }
}

// MARK: - Alert - Add, Update Method
extension VocaListViewModel {
    func showAlertWithTextField(newData: RealmVocaModel?) {
        let alert = configureAlert(newData: newData)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cancelAction)
        alertPublisher.send(alert)
    }

    private func configureAlert(newData: RealmVocaModel?) -> UIAlertController {
        let alert = UIAlertController(title: "단어와 뜻을 입력해 주세요.", message: nil, preferredStyle: .alert)
        if let newData = newData {
            addTextFields(to: alert, sourceText: newData.sourceText, translatedText: newData.translatedText)
            addAction(to: alert, for: newData)
        } else {
            addPlaceholders(to: alert)
            addAction(for: alert)
        }
        return alert
    }
    private func addTextFields(to alert: UIAlertController, sourceText: String, translatedText: String) {
        alert.addTextField { textField in
            textField.text = sourceText
        }
        alert.addTextField { textField in
            textField.text = translatedText
        }
    }

    private func addPlaceholders(to alert: UIAlertController) {
        alert.addTextField { textField in
            textField.placeholder = "단어를 입력해 주세요."
        }
        alert.addTextField { textField in
            textField.placeholder = "뜻을 입력해 주세요."
        }
    }
    private func addAction(to alert: UIAlertController, for newData: RealmVocaModel) {
        let saveAction = UIAlertAction(title: "Save", style: .default) { [weak self, weak alert] _ in
            guard let self = self,
                  let alert = alert,
                  let sourcetextField = alert.textFields?[0],
                  let sourcetext = sourcetextField.text,
                  let translatedtextField = alert.textFields?[1],
                  let translatedtext = translatedtextField.text else {
                return
            }
            self.updateVoca(list: newData,
                       sourceText: sourcetext,
                       translatedText: translatedtext,
                       isSelected: newData.isSelected)
            let newVocaList: [RealmVocaModel] = self.getVocaList()
            self.tableViewUpdate.send(newVocaList)
        }
        alert.addAction(saveAction)
    }

    private func addAction(for alert: UIAlertController) {
        let saveAction = UIAlertAction(title: "Save", style: .default) { [weak self, weak alert] _ in
            guard let self = self,
                  let alert = alert,
                  let sourcetextField = alert.textFields?[0],
                  let sourcetext = sourcetextField.text,
                  let translatedtextField = alert.textFields?[1],
                  let translatedtext = translatedtextField.text else {
                return
            }
            let voca = RealmVocaModel(sourceText: sourcetext, translatedText: translatedtext)
            if !self.isVocaAlreadyExists(voca) {
                self.addVoca(voca)
                let newVocaList: [RealmVocaModel] = self.getVocaList()
                self.tableViewUpdate.send(newVocaList)
            } else {
                print("이미 존재하는 데이터입니다.")
            }
        }
        alert.addAction(saveAction)
    }
  private  func isVocaAlreadyExists(_ voca: RealmVocaModel) -> Bool {
        let existingVocaList: [RealmVocaModel] = getVocaList()
        return existingVocaList.contains { $0.sourceText == voca.sourceText
                                        && $0.translatedText == voca.translatedText }
    }
}
