//
//  APIRealmVocaModel.swift
//  VocaWeaveApp
//
//  Created by 천광조 on 12/13/23.
//

import Foundation
import RealmSwift

final class APIRealmVocaModel: Object {
    @Persisted var uuid = UUID()
    @Persisted var sourceText: String
    @Persisted var translatedText: String
    @Persisted var isSelected: Bool
    @Persisted var section: String

    convenience init(translatedText: String, sourceText: String) {
        self.init()
        self.sourceText = sourceText
        self.translatedText = translatedText
        self.isSelected = false
        self.section = sourceText.getFirstLetter()
    }

    convenience init(sourceText: String, translatedText: String, isSelected: Bool) {
        self.init()
        self.sourceText = sourceText
        self.translatedText = translatedText
        self.isSelected = isSelected
        self.section = sourceText.getFirstLetter()
    }
}
