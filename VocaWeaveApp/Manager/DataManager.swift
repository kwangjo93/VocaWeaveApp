//
//  DataManager.swift
//  VocaWeaveApp
//
//  Created by 천광조 on 12/13/23.
//

import Foundation
import RealmSwift

class VocaListManager: VocaListType {
    private var realm: Realm? {
        do {
            return try Realm()
        } catch {
            print("Realm 생성 에러 : \(error.localizedDescription)")
            return nil
        }
    }

    private var list: Results<RealmTranslateReponseModel>? {
        return realm?.objects(RealmTranslateReponseModel.self)
    }

    var vocaList: [RealmTranslateReponseModel] {
        if let todos = list {
            return Array(todos)
        } else {
            return []
        }
    }

    func makeNewList(_ list: RealmTranslateReponseModel) {
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

    func updateListInfo(list: RealmTranslateReponseModel, text: String, isSelected: Bool) {
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

    func deleteList(_ list: RealmTranslateReponseModel) {
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
