//
//  UserProfileListItemViewModel.swift
//  Moments
//
//  Created by Jake Lin on 25/7/21.
//

import Foundation

struct UserProfileListItemViewModel: ListItemViewModel, Identifiable  {
    let id: UUID = .init()
    let name: String
    let avatarURL: URL?
    let backgroundImageURL: URL?

    init(userDetails: MomentsDetails.UserDetails) {
        name = userDetails.name
        avatarURL = URL(string: userDetails.avatar)
        backgroundImageURL = URL(string: userDetails.backgroundImage)
    }
}
