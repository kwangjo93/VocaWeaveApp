//
//  DataManager.swift
//  VocaWeaveApp
//
//  Created by 천광조 on 12/13/23.
//

import Foundation

class VocaListManager: VocaListType {
    private var vocaList: [RealmTranslateReponseModel] = []

    func getvocaList() -> [RealmTranslateReponseModel] {
        return vocaList
    }

    func makeNewMember(_ list: RealmTranslateReponseModel) {
        vocaList.append(list)
    }

    func updateListInfo(index: Int, with list: RealmTranslateReponseModel) {
        vocaList[index] = list
    }

//    func deleteListInfo(list: RealmTranslateReponseModel) {
//        vocaList.removeAll(where: {$0.id == list.id})
//    }
}
