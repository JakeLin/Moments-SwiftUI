//
//  APIService.swift
//  APIService
//
//  Created by Jake Lin on 27/7/21.
//

import Foundation

protocol APIService { }

extension APIService {
    func request<T: Decodable>(variables: [AnyHashable: Encodable], parameters: [String: Any], forType type: T.Type) async throws -> T {
        guard let url = API.baseURL else { throw APINetworkingError.invalidURL }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        guard let requestBody = try? JSONSerialization.data(withJSONObject: parameters) else { throw APINetworkingError.invalidParameter }
        request.httpBody = requestBody

        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APINetworkingError.networkURLError
        }
        guard (200..<300).contains(httpResponse.statusCode) else {
            throw APINetworkingError.networkStatusError(httpResponse.statusCode)
        }

        guard let reponse = try? JSONDecoder().decode(type, from: data) else {
            throw APINetworkingError.invalidResponseJSON
        }

        return reponse
    }
}
