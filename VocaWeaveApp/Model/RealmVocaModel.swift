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

    convenience init(sourceText: String, translatedText: String) {
        self.init()
        self.sourceText = sourceText
        self.translatedText = translatedText
        self.isSelected = false
        self.section = (sourceText.first?.uppercased())!
    }
}
