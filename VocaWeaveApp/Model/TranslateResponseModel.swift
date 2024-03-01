//
//  TranslateResponseModel.swift
//  VocaWeaveApp
//
//  Created by 천광조 on 12/12/23.
//

import Foundation
import RealmSwift

// APIData
    struct APIReponseModel: Decodable {
        let translations: [Translation]
    }
    struct Translation: Codable {
        let text: String

        enum CodingKeys: String, CodingKey {
            case text
        }
    }
