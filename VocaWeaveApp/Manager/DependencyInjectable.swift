//
//  DependencyInjectable.swift
//  VocaWeaveApp
//
//  Created by 천광조 on 12/13/23.
//

import Foundation

protocol VocaListType {
    var vocaList: [RealmTranslateReponseModel] { get }
    func makeNewList(_ list: RealmTranslateReponseModel)
    func updateListInfo(list: RealmTranslateReponseModel, text: String, isSelected: Bool)
    func deleteList(_ list: RealmTranslateReponseModel)
}
