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
    @Persisted var sourceText: String
    @Persisted var translatedText: String
    @Persisted var isSelected: Bool
    @Persisted var section: String

    convenience init(apiModel: TranslateReponseModel, sourceText: String) {
        self.init()
        self.sourceText = sourceText
        self.translatedText = apiModel.translatedText
        self.isSelected = false
        self.section = sourceText.getFirstLetter()
    }
}
