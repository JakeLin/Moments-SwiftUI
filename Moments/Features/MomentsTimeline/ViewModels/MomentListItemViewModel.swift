//
//  MomentListItemViewModel.swift
//  Moments
//
//  Created by Jake Lin on 25/7/21.
//

import Foundation

struct MomentListItemViewModel: ListItemViewModel, Identifiable {    
    let id: UUID = .init()
    let userAvatarURL: URL?
    let userName: String
    let title: String?
    let photoURL: URL? // This version only supports one image
    let postDateDescription: String?
    let isLiked: Bool
    let likes: [URL]

    private let momentID: String
    private let momentsRepo: MomentsRepo

    init(moment: MomentsDetails.Moment, momentsRepo: MomentsRepo = MomentsRepo.shared, now: Date = Date(), relativeDateTimeFormatter: RelativeDateTimeFormatterType = RelativeDateTimeFormatter()) {
        momentID = moment.id
        self.momentsRepo = momentsRepo
        userAvatarURL = URL(string: moment.userDetails.avatar)
        userName = moment.userDetails.name
        title = moment.title
        isLiked = moment.isLiked
        likes = moment.likes.compactMap { URL(string: $0.avatar) }

        if let firstPhoto = moment.photos.first {
            photoURL = URL(string: firstPhoto)
        } else {
            photoURL = nil
        }

        var formatter = relativeDateTimeFormatter
        formatter.unitsStyle = .full
        if let timeInterval = TimeInterval(moment.createdDate) {
            let createdDate = Date(timeIntervalSince1970: timeInterval)
            postDateDescription = formatter.localizedString(for: createdDate, relativeTo: now)
        } else {
            postDateDescription = nil
        }
    }

    func like(from userID: String) async throws -> MomentsDetails {
        return try await momentsRepo.updateLike(isLiked: true, momentID: momentID, fromUserID: userID)
    }

    func unlike(from userID: String) async throws -> MomentsDetails {
        return try await momentsRepo.updateLike(isLiked: false, momentID: momentID, fromUserID: userID)
    }
}