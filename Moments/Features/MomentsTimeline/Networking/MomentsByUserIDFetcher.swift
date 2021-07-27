//
//  MomentsByUserIDFetcher.swift
//  Moments
//
//  Created by Jake Lin on 25/7/21.
//

import Foundation

protocol MomentsByUserIDFetcherType {
    func fetchMoments(userID: String) async throws -> MomentsDetails
}

struct MomentsByUserIDFetcher: MomentsByUserIDFetcherType, APIService {
    func fetchMoments(userID: String) async throws -> MomentsDetails {
        struct Response: Decodable {
            let data: Data

            struct Data: Decodable {
                let getMomentsDetailsByUserID: MomentsDetails
            }
        }

        let query = """
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

        let variables: [AnyHashable: Encodable] = ["userID": userID]
        let parameters: [String: Any] = ["query": query, "variables": variables]

        let response = try await request(variables: variables, parameters: parameters, forType: Response.self)
        return response.data.getMomentsDetailsByUserID
    }
}
