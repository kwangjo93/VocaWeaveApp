//
//  TranslateResponseModel.swift
//  VocaWeaveApp
//
//  Created by 천광조 on 12/12/23.
//

import Foundation

// APIData
struct TranslateReponseModel: Decodable {
    private let message: Message
        struct Message: Decodable {
            let result: Result
        }
            struct Result: Decodable {
                let translatedText: String
            }

    var translatedText: String { message.result.translatedText }
}
