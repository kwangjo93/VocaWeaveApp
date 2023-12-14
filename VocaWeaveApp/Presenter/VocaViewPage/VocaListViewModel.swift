//
//  vocaListViewModel.swift
//  VocaWeaveApp
//
//  Created by 천광조 on 12/14/23.
//

import UIKit
import Combine

class VocaListViewModel {
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

    func addVoca(_ list: RealmVocaModel) {
        datamanager.makeNewList(list)
    }

    func updateVoca(list: RealmVocaModel, text: String, isSelected: Bool) {
        datamanager.updateListInfo(list: list, text: text, isSelected: isSelected)
    }

    func deleteVoca(_ list: RealmVocaModel) {
        datamanager.deleteList(list)
    }

    func showAlertWithTextField() {
        let alert = UIAlertController(title: "단어어와 뜻을 입력해 주세요.",
                                      message: nil,
                                      preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "단어를 입력해 주세요."
        }

        alert.addTextField { textField in
            textField.placeholder = "뜻을 입력해 주세요."
        }

        let saveAction = UIAlertAction(title: "Save", style: .default) { [weak alert] _ in
            guard let sourcetextField = alert?.textFields?[0],
                  let sourcetext = sourcetextField.text else { return }
            guard let translatedtextField = alert?.textFields?[1],
                  let translatedtext = translatedtextField.text else { return }
            let voca = RealmVocaModel(sourceText: sourcetext, translatedText: translatedtext)
            self.addVoca(voca)
            let newVocaList: [RealmVocaModel] = self.getVocaList()
            self.tableViewUpdate.send(newVocaList)
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        alertPublisher.send(alert)
    }

}
