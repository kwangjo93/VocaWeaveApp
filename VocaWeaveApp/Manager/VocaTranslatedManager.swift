//
//  DataManager.swift
//  VocaWeaveApp
//
//  Created by 천광조 on 12/13/23.
//

import Foundation
import RealmSwift

class VocaTranslatedManager: RealmTranslateType {
    private var realm: Realm? {
        do {
            return try Realm()
        } catch {
            print("Realm 생성 에러 : \(error.localizedDescription)")
            return nil
        }
    }

    private var list: Results<RealmTranslateModel>? {
        return realm?.objects(RealmTranslateModel.self)
    }

    var vocaList: [RealmTranslateModel] {
        if let lists = list {
            return Array(lists)
        } else {
            return []
        }
    }

    func makeNewList(_ list: RealmTranslateModel) {
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

    func updateListInfo(list: RealmTranslateModel, text: String, isSelected: Bool) {
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

    func deleteList(_ list: RealmTranslateModel) {
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
