//
//  NetworkingManager.swift
//  VocaWeaveApp
//
//  Created by 천광조 on 12/12/23.
//

import UIKit

final class NetworkingManager {
    static let shared = NetworkingManager()
    private init() {}

    func fetchData(source: String, target: String, text: String) async throws -> TranslateReponseModel {
        guard let file = Bundle.main.path(
            forResource: "APIInfo",
            ofType: "plist") else { throw NetworkError.invalidFile }
        guard let resource = NSDictionary(contentsOfFile: file),
              let keyId = resource["API_id"] as? String,
              let keyscret = resource["API_scret"] as? String else {
            throw NetworkError.invalidCredentials
        }

        guard let url = URL(string: "https://openapi.naver.com/v1/papago/n2mt") else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)

        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue(keyId, forHTTPHeaderField: "X-Naver-Client-Id")
        request.setValue(keyscret, forHTTPHeaderField: "X-Naver-Client-Secret")
        let stringWithParameters = "source=\(source)&target=\(target)&text=\(text)"
        let data = stringWithParameters.data(using: .utf8)!
        request.httpBody = data

        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            if let httpResponse = response as? HTTPURLResponse, (400...499).contains(httpResponse.statusCode) {
                throw NetworkError.httpError
            }
            let decodedData = try JSONDecoder().decode(TranslateReponseModel.self, from: data)
            return decodedData
        } catch {
            throw NetworkError.decodingError
        }
    }
}
