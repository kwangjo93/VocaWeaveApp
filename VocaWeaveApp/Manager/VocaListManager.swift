//
//  VocaListManager.swift
//  VocaWeaveApp
//
//  Created by 천광조 on 12/14/23.
//

import Foundation
import RealmSwift

class VocaListManager: RealmVocaModelType {
    private var realm: Realm? {
        do {
            return try Realm()
        } catch {
            print("Realm 생성 에러 : \(error.localizedDescription)")
            return nil
        }
    }

    private var vocaList: Results<RealmVocaModel>? {
        return realm?.objects(RealmVocaModel.self)
    }

    private func queryVocaData(query: String) -> Results<RealmVocaModel>? {
        return realm?.objects(RealmVocaModel.self).filter("realmQeury == %@", query)
    }

    func getAllVocaData() -> [RealmVocaModel] {
        if let todos = vocaList {
            return Array(todos)
        } else {
            return []
        }
    }

    func getVocaList(query: String) -> [RealmVocaModel] {
        if let todos = queryVocaData(query: query) {
            return Array(todos)
        } else {
            print("값 불로오기 실패")
            return []
        }
    }

    func makeNewList(_ list: RealmVocaModel) {
        guard let realm = realm else {
            print("Realm is nil")
            return
        }

        do {
            try realm.write {
                realm.add(list)
            }
        } catch {
            print("추가 에러 발생 : \(error.localizedDescription)")
        }
    }

    func updateListInfo(list: RealmVocaModel,
                        sourceText: String,
                        translatedText: String,
                        isSelected: Bool) {
        guard let realm = realm else {
            print("Realm is nil")
            return
        }

        do {
            try realm.write {
                list.sourceText = sourceText
                list.translatedText = translatedText
                list.isSelected = isSelected
            }
        } catch {
            print("업데이트 에러: \(error.localizedDescription)")
        }
    }

    func deleteList(_ list: RealmVocaModel) {
            do {
                guard let realm = realm else { return }
                try realm.write {
                    realm.delete(list)
                }
            } catch {
                print("삭제 에러: \(error.localizedDescription)")
            }
        }
}
