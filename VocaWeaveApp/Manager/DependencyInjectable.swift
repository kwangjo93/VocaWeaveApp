//
//  DependencyInjectable.swift
//  VocaWeaveApp
//
//  Created by 천광조 on 12/13/23.
//

import Foundation
import RealmSwift

protocol APIRealmVocaModelType {
    func getVocaList() -> [APIRealmVocaModel]
    func makeNewList(_ list: APIRealmVocaModel)
    func updateListInfo(list: APIRealmVocaModel, text: String, isSelected: Bool)
    func deleteList(_ list: APIRealmVocaModel)
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
}
