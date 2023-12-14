//
//  VocaViewModel.swift
//  VocaWeaveApp
//
//  Created by 천광조 on 12/8/23.
//

import Foundation
import Combine
import RealmSwift

class VocaTranslatedViewModel {
    let datamanager: RealmTranslateType

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

}
