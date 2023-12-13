//
//  VocaViewModel.swift
//  VocaWeaveApp
//
//  Created by 천광조 on 12/8/23.
//

import Foundation

class VocaViewModel {
    let datamanager: VocaListType

    init(datamanager: VocaListType) {
        self.datamanager = datamanager
    }

    lazy var vocaList = datamanager.vocaList

    func addVoca(_ list: RealmTranslateReponseModel) {
        datamanager.makeNewList(list)
    }

    func updateVoca(list: RealmTranslateReponseModel, text: String, isSelected: Bool) {
        datamanager.updateListInfo(list: list, text: text, isSelected: isSelected)
    }

    func deleteVoca(_ list: RealmTranslateReponseModel) {
        datamanager.deleteList(list)
    }
}
