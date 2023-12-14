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

    private var list: Results<RealmVocaModel>? {
        return realm?.objects(RealmVocaModel.self)
    }

    func getVocaList() -> [RealmVocaModel] {
        if let todos = list {
            return Array(todos)
        } else {
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

    func updateListInfo(list: RealmVocaModel, text: String, isSelected: Bool) {
        guard let realm = realm else {
            print("Realm is nil")
            return
        }

        do {
            try realm.write {
                list.translatedText = text
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
