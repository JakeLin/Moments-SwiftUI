//
//  MomentsDetails.swift
//  Moments
//
//  Created by Jake Lin on 25/7/21.
//

import Foundation

struct MomentsDetails: Decodable {
    let userDetails: UserDetails
    let moments: [Moment]

    struct UserDetails: Decodable {
        let id: String
        let name: String
        let avatar: String
        let backgroundImage: String
    }

    struct Moment: Decodable {
        let id: String
        let userDetails: MomentUserDetails
        let type: MomentType
        let title: String?
        let url: String?
        let photos: [String]
        let createdDate: String
        let isLiked: Bool
        let likes: [LikedUserDetails]

        struct MomentUserDetails: Decodable {
            let name: String
            let avatar: String
        }

        struct LikedUserDetails: Decodable {
            let id: String
            let avatar: String
        }

        enum MomentType: String, Decodable {
            case url = "URL"
            case photos = "PHOTOS"
        }
    }
}
