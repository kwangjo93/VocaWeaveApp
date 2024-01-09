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
}
