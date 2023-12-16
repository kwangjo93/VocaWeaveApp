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
        let alert = UIAlertController(title: "단어와 뜻을 입력해 주세요.", message: nil, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "단어를 입력해 주세요."
        }

        alert.addTextField { textField in
            textField.placeholder = "뜻을 입력해 주세요."
        }

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

            // 이미 존재하는지 확인하고 중복된 데이터를 추가하지 않음
            if !self.isVocaAlreadyExists(voca) {
                self.addVoca(voca)
                let newVocaList: [RealmVocaModel] = self.getVocaList()
                self.tableViewUpdate.send(newVocaList)
            } else {
                // 이미 존재하는 데이터라는 메시지 출력 또는 다른 처리
                print("이미 존재하는 데이터입니다.")
            }
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        alertPublisher.send(alert)
    }

  private  func isVocaAlreadyExists(_ voca: RealmVocaModel) -> Bool {
        // 이미 존재하는 데이터인지 확인하는 로직
        let existingVocaList: [RealmVocaModel] = getVocaList()
        return existingVocaList.contains { $0.sourceText == voca.sourceText
                                        && $0.translatedText == voca.translatedText }
    }

    func toggleHeaderVisibility(sectionTitle: String, headerView: VocaTableViewHeaderView) {
        let itemsInSection = getVocaList().filter { $0.section == sectionTitle }
        headerView.isHidden = itemsInSection.isEmpty
        if let tableView = headerView.superview as? UITableView {
            tableView.reloadData()
        }
    }
}
