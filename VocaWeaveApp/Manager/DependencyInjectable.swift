//
//  DependencyInjectable.swift
//  VocaWeaveApp
//
//  Created by 천광조 on 12/13/23.
//

import Foundation

protocol VocaListType {
    func getvocaList() -> [RealmTranslateReponseModel]
    func makeNewMember(_ list: RealmTranslateReponseModel)
    func updateListInfo(index: Int, with list: RealmTranslateReponseModel)
//    func deleteListInfo(list: RealmTranslateReponseModel)
}
