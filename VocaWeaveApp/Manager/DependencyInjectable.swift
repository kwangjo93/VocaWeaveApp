//
//  DependencyInjectable.swift
//  VocaWeaveApp
//
//  Created by 천광조 on 12/13/23.
//

import Foundation
import RealmSwift

protocol RealmTranslateType {
    func getVocaList() -> [RealmTranslateModel]
    func makeNewList(_ list: RealmTranslateModel)
    func updateListInfo(list: RealmTranslateModel, text: String, isSelected: Bool)
    func deleteList(_ list: RealmTranslateModel)
    func deleteAllData()
}

protocol RealmVocaModelType {
    func getAllVocaData() -> [RealmVocaModel]
    func getVocaList(query: String) -> [RealmVocaModel]
    func makeNewList(_ list: RealmVocaModel)
    func updateListInfo(list: RealmVocaModel,
                        sourceText: String,
                        translatedText: String,
                        isSelected: Bool)
    func deleteList(_ list: RealmVocaModel)
    func deleteAllData(query: String)
}
