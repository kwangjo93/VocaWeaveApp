//
//  TranslateRequestModel.swift
//  VocaWeaveApp
//
//  Created by 천광조 on 12/12/23.
//

import Foundation

// 필수 파라미터
struct TranslateRequestModel: Codable {
    let source: String
    let target: String
    let text: String
}
