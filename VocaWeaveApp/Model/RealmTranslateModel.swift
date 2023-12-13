//
//  RealmTranslateReponseModel.swift
//  VocaWeaveApp
//
//  Created by 천광조 on 12/13/23.
//

import Foundation
import RealmSwift

class RealmTranslateModel: Object {
    @Persisted var uuid = UUID()
    @Persisted var translatedText: String
    @Persisted var isSelected: Bool
    convenience init(apiModel: TranslateReponseModel) {
        self.init()
        self.translatedText = apiModel.translatedText
        self.isSelected = false
    }
}
