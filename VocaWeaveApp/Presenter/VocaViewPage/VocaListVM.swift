//
//  VocaListVM.swift
//  VocaWeaveApp
//
//  Created by 천광조 on 12/14/23.
//

import UIKit
import Combine

final class VocaListVM {
    // MARK: - Property
    private let realmQuery = "myVoca"
    let datamanager: RealmVocaModelType
    let alertPublisher = PassthroughSubject<UIAlertController, Never>()
    let tableViewUpdate = PassthroughSubject<[RealmVocaModel], Never>()
    let whitespacesAlertPublisher = PassthroughSubject<UIAlertController, Never>()
    // MARK: - init
    init(datamanager: RealmVocaModelType) {
        self.datamanager = datamanager
    }
    // MARK: - Action
    func getMyVocaList() -> [RealmVocaModel] {
        return datamanager.getVocaList(query: realmQuery)
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
}
// MARK: - Alert - Add, Update Method
extension VocaListVM {
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
            addAlertAction(to: alert, for: newData)
        } else {
            addPlaceholders(to: alert)
            addAlertAction(for: alert)
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
    private func addAlertAction(to alert: UIAlertController, for newData: RealmVocaModel) {
        let saveAction = UIAlertAction(title: "Save", style: .default) { [weak self, weak alert] _ in
            guard let self = self,
                  let alert = alert,
                  let sourcetextField = alert.textFields?[0],
                  let sourcetext = sourcetextField.text,
                  let translatedtextField = alert.textFields?[1],
                  let translatedtext = translatedtextField.text else {
                return
            }
            if sourcetext.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
                translatedtext.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                self.showEmptyTextFieldAlert()
                return
            }
            self.updateVoca(list: newData,
                       sourceText: sourcetext,
                       translatedText: translatedtext,
                       isSelected: newData.isSelected)
            let newVocaList: [RealmVocaModel] = self.getMyVocaList()
            self.tableViewUpdate.send(newVocaList)
        }
        alert.addAction(saveAction)
    }

    private func addAlertAction(for alert: UIAlertController) {
        let saveAction = UIAlertAction(title: "Save", style: .default) { [weak self, weak alert] _ in
            guard let self = self,
                  let alert = alert,
                  let sourcetextField = alert.textFields?[0],
                  let sourcetext = sourcetextField.text,
                  let translatedtextField = alert.textFields?[1],
                  let translatedtext = translatedtextField.text else {
                return
            }
            if sourcetext.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
                translatedtext.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                self.showEmptyTextFieldAlert()
                return
            }
            let voca = RealmVocaModel(sourceText: sourcetext, translatedText: translatedtext, realmQeury: realmQuery)
            if !self.isVocaAlreadyExists(voca) {
                self.addVoca(voca)
                let newVocaList: [RealmVocaModel] = self.getMyVocaList()
                self.tableViewUpdate.send(newVocaList)
            } else {
                print("이미 존재하는 데이터입니다.")
            }
        }
        alert.addAction(saveAction)
    }

    private func showEmptyTextFieldAlert() {
        let alert = UIAlertController(title: "경고", message: "단어가 비어 있습니다.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        whitespacesAlertPublisher.send(alert)
    }

  private  func isVocaAlreadyExists(_ voca: RealmVocaModel) -> Bool {
        let existingVocaList: [RealmVocaModel] = getMyVocaList()
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
        cell.speakerButtonAction()
        cell.selectionStyle = .none
    }
}