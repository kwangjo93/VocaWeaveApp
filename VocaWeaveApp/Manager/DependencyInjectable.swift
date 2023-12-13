//
//  DependencyInjectable.swift
//  VocaWeaveApp
//
//  Created by 천광조 on 12/13/23.
//

import Foundation

protocol VocaListType {
    var vocaList: [RealmTranslateModel] { get }
    func makeNewList(_ list: RealmTranslateModel)
    func updateListInfo(list: RealmTranslateModel, text: String, isSelected: Bool)
    func deleteList(_ list: RealmTranslateModel)
}
