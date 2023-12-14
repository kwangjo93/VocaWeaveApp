//
//  DependencyInjectable.swift
//  VocaWeaveApp
//
//  Created by 천광조 on 12/13/23.
//

import Foundation
import RealmSwift

protocol RealmTranslateType {
    var vocaList: [RealmTranslateModel] { get }
    func makeNewList(_ list: RealmTranslateModel)
    func updateListInfo(list: RealmTranslateModel, text: String, isSelected: Bool)
    func deleteList(_ list: RealmTranslateModel)
}

protocol RealmVocaModelType {
    var vocaList: [RealmVocaModel] { get }
    func makeNewList(_ list: RealmVocaModel)
    func updateListInfo(list: RealmVocaModel, text: String, isSelected: Bool)
    func deleteList(_ list: RealmVocaModel)
}
