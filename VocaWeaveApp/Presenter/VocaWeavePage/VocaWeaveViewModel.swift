//
//  VocaWeaveViewModel.swift
//  VocaWeaveApp
//
//  Created by 천광조 on 12/11/23.
//

import Foundation

class VocaWeaveViewModel {
    // MARK: - Property
    private let vocaListManager: VocaListManager
    private let realmQuery = "myVoca"
    // MARK: - init
    init(vocaListManager: VocaListManager) {
        self.vocaListManager = vocaListManager
    }

    // MARK: - Action
    func getVocaList() -> [RealmVocaModel] {
        return vocaListManager.getVocaList(query: realmQuery)
    }
}
