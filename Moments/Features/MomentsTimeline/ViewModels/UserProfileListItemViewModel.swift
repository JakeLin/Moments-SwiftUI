//
//  UserProfileListItemViewModel.swift
//  Moments
//
//  Created by Jake Lin on 25/7/21.
//

import Foundation

struct UserProfileListItemViewModel: ListItemViewModel, Identifiable {
    let name: String
    let avatarURL: URL?
    let backgroundImageURL: URL?

    var id: String {
        return "user-\(userID)"
    }

    private let userID: String

    init(userDetails: MomentsDetails.UserDetails) {
        userID = userDetails.id
        name = userDetails.name
        avatarURL = URL(string: userDetails.avatar)
        backgroundImageURL = URL(string: userDetails.backgroundImage)
    }
}
