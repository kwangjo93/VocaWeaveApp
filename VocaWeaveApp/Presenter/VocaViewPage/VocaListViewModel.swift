//
//  vocaListViewModel.swift
//  VocaWeaveApp
//
//  Created by 천광조 on 12/14/23.
//

import Foundation
import Combine

class VocaListViewModel {
    let datamanager: RealmVocaModelType

    init(datamanager: RealmVocaModelType) {
        self.datamanager = datamanager
    }

    lazy var vocaList = datamanager.vocaList

    func addVoca(_ list: RealmVocaModel) {
        datamanager.makeNewList(list)
    }

    func updateVoca(list: RealmVocaModel, text: String, isSelected: Bool) {
        datamanager.updateListInfo(list: list, text: text, isSelected: isSelected)
    }

    func deleteVoca(_ list: RealmVocaModel) {
        datamanager.deleteList(list)
    }
}
