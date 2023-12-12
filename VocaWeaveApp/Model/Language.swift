//
//  Language.swift
//  VocaWeaveApp
//
//  Created by 천광조 on 12/12/23.
//

import Foundation
enum Language: String, Codable {
    case ko
    case en

    var languageCode: String {
        self.rawValue
    }
}
