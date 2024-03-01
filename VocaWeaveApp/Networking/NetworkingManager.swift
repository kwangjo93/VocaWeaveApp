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

    func fetchData(source: String,
                   target: String,
                   text: String) async throws -> String {
        guard let file = Bundle.main.path(forResource: "APIInfo", ofType: "plist")
                                                                    else { throw NetworkError.invalidFile }
        guard let resource = NSDictionary(contentsOfFile: file),
              let apiKey = resource["API_key"] as? String else {
            throw NetworkError.invalidCredentials
        }

        guard let url = URL(string: "https://api-free.deepl.com/v2/translate") else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("DeepL-Auth-Key \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let requestData: [String: Any] = [
            "text": [text],
            "target_lang": target
        ]
        let jsonData = try JSONSerialization.data(withJSONObject: requestData, options: [])
        request.httpBody = jsonData

        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            if let httpResponse = response as? HTTPURLResponse, (400...499).contains(httpResponse.statusCode) {
                print(response)
                throw NetworkError.httpError
            }
            let decodedData = try JSONDecoder().decode(APIReponseModel.self, from: data)
            return decodedData.translations.first?.text ?? ""
        } catch {
            print(error)
            throw NetworkError.decodingError
        }
    }
}
