//
//  MomentsRepo.swift
//  Moments
//
//  Created by Jake Lin on 25/7/21.
//

import Foundation

protocol MomentsRepoType {
    func getMoments(userID: String) async throws -> MomentsDetails
    func updateLike(isLiked: Bool, momentID: String, fromUserID userID: String) async throws -> MomentsDetails
}

final actor MomentsRepo: MomentsRepoType {
    private let momentsByUserIDFetcher: MomentsByUserIDFetcherType

    static let shared: MomentsRepo = {
        return MomentsRepo(
            momentsByUserIDFetcher: MomentsByUserIDFetcher()
        )
    }()

    init(momentsByUserIDFetcher: MomentsByUserIDFetcherType) {
        self.momentsByUserIDFetcher = momentsByUserIDFetcher
    }

    func getMoments(userID: String) async throws -> MomentsDetails {
        return try await momentsByUserIDFetcher.fetchMoments(userID: userID)
    }

    func updateLike(isLiked: Bool, momentID: String, fromUserID userID: String) async throws -> MomentsDetails {
        fatalError()
    }
}
