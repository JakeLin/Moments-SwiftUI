//
//  MomentsByUserIDFetcher.swift
//  Moments
//
//  Created by Jake Lin on 25/7/21.
//

import Foundation

enum APINetworkingError: Error {
    case invalidURL
    case invalidParameter
    case networkURLError
    case networkStatusError(Int)
    case invalidResponseJSON
    case noData
}

protocol MomentsByUserIDFetcherType {
    func fetchMoments(userID: String) async throws -> MomentsDetails
}

struct MomentsByUserIDFetcher: MomentsByUserIDFetcherType {
    private struct Response: Decodable {
        let data: Data

        struct Data: Decodable {
            let getMomentsDetailsByUserID: MomentsDetails
        }
    }

    func fetchMoments(userID: String) async throws -> MomentsDetails {
        guard let url = API.baseURL else { throw APINetworkingError.invalidURL }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let variables: [AnyHashable: Encodable] = ["userID": userID]
        let parameters: [String: Any] = ["query": query,
                      "variables": variables]
        guard let requestBody = try? JSONSerialization.data(withJSONObject: parameters) else { throw APINetworkingError.invalidParameter }
        request.httpBody = requestBody

        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APINetworkingError.networkURLError
        }
        guard (200..<300).contains(httpResponse.statusCode) else {
            throw APINetworkingError.networkStatusError(httpResponse.statusCode)
        }

        guard let responseJSON = try? JSONDecoder().decode(Response.self, from: data) else {
            throw APINetworkingError.invalidResponseJSON
        }

        return responseJSON.data.getMomentsDetailsByUserID
    }
}

private extension MomentsByUserIDFetcher {
    var query: String {
        return """
           query getMomentsDetailsByUserID($userID: ID!) {
             getMomentsDetailsByUserID(userID: $userID) {
               userDetails {
                 id
                 name
                 avatar
                 backgroundImage
               }
               moments {
                 id
                 userDetails {
                   name
                   avatar
                 }
                 type
                 title
                 photos
                 createdDate
                 isLiked
                 likes {
                   id
                   avatar
                 }
               }
             }
           }
        """
    }
}
