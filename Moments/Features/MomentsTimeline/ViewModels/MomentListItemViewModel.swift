//
//  MomentListItemViewModel.swift
//  Moments
//
//  Created by Jake Lin on 25/7/21.
//

import Foundation

final class MomentListItemViewModel: ListItemViewModel, Identifiable, ObservableObject {
    let userAvatarURL: URL?
    let userName: String
    let title: String?
    let photoURL: URL? // This version only supports one image
    let postDateDescription: String?
    let isLiked: Bool
    @Published private(set) var likes: [URL]

    var id: String {
        return "moment-\(momentID)"
    }

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

    @MainActor
    func like(from userID: String) async throws {
        let momentsDetails = try await momentsRepo.updateLike(isLiked: true, momentID: momentID, fromUserID: userID)
        likes = momentsDetails.moments.first { $0.id == momentID }?.likes.compactMap { URL(string: $0.avatar) } ?? []
    }

    @MainActor
    func unlike(from userID: String) async throws {
        let momentsDetails = try await momentsRepo.updateLike(isLiked: false, momentID: momentID, fromUserID: userID)
        likes = momentsDetails.moments.first { $0.id == momentID }?.likes.compactMap { URL(string: $0.avatar) } ?? []
    }
}
