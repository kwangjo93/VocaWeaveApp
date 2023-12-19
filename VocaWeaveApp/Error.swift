//
//  Error.swift
//  VocaWeaveApp
//
//  Created by 천광조 on 12/12/23.
//

import Foundation

enum NetworkError: Error {
    case invalidFile
    case invalidURL
    case invalidCredentials
    case httpError
    case decodingError
}
