//
//  Language.swift
//  VocaWeaveApp
//
//  Created by 천광조 on 12/12/23.
//

import Foundation
enum Language: String {
    case korean = "ko"
    case english = "en"

    static var sourceLanguage: Language = .korean
    static var targetLanguage: Language = .english

    var languageCode: String {
        self.rawValue
    }

    var avLanguageTitle: String {
        switch self {
        case .korean:
            return "ko-KR"
        case .english:
            return "en-US"
        }
    }

    static func detectLanguage(text: String) -> Bool {
        if text.containsOnlyKorean() {
            sourceLanguage = .korean
            targetLanguage = .english
            return true
        } else if text.containsOnlyEnglish() {
            sourceLanguage = .english
            targetLanguage = .korean
           return true
        }
        return false
    }
}
