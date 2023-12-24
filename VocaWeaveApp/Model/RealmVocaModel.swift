//
//  RealmVocaModel.swift
//  VocaWeaveApp
//
//  Created by 천광조 on 12/14/23.
//

import Foundation
import RealmSwift

class RealmVocaModel: Object {
    @Persisted var uuid = UUID()
    @Persisted var sourceText: String
    @Persisted var translatedText: String
    @Persisted var isSelected: Bool
    @Persisted var section: String
    @Persisted var realmQeury: String

    convenience init(sourceText: String, translatedText: String, realmQeury: String) {
        self.init()
        self.sourceText = sourceText
        self.translatedText = translatedText
        self.isSelected = false
        self.section = sourceText.getFirstLetter()
        self.realmQeury = realmQeury
    }
}
