//
//  MomentLikeUpdater.swift
//  MomentLikeUpdater
//
//  Created by Jake Lin on 27/7/21.
//

import Foundation

protocol MomentLikeUpdaterType {
    func updateLike(_ isLiked: Bool, momentID: String, fromUserID userID: String) async throws -> MomentsDetails
}

struct MomentLikeUpdater: MomentLikeUpdaterType, APIService {
    func updateLike(_ isLiked: Bool, momentID: String, fromUserID userID: String) async throws -> MomentsDetails {
        struct Response: Decodable {
            let data: Data

            struct Data: Decodable {
                let updateMomentLike: MomentsDetails
            }
        }

        let query = """
           mutation updateMomentLike($momentID: ID!, $userID: ID!, $isLiked: Boolean!) {
             updateMomentLike(momentID: $momentID, userID: $userID, isLiked: $isLiked) {
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

        let variables: [AnyHashable: Encodable] = ["momentID": momentID,
                                                   "userID": userID,
                                                   "isLiked": isLiked]
        let parameters: [String: Any] = ["query": query, "variables": variables]

        let response = try await request(variables: variables, parameters: parameters, forType: Response.self)
        return response.data.updateMomentLike
    }
}
