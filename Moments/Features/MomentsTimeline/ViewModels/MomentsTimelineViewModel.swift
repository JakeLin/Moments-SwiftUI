//
//  MomentsTimelineViewModel.swift
//  Moments
//
//  Created by Jake Lin on 25/7/21.
//

import Foundation

final class MomentsTimelineViewModel: ObservableObject {
    @Published private(set) var listItems: [ListItemViewModelType] = []

    private let momentsRepo: MomentsRepoType

    init(momentsRepo: MomentsRepoType = MomentsRepo.shared) {
        self.momentsRepo = momentsRepo
    }

    @MainActor
    func loadItems(userID: String) async throws {
        let momentsDetails = try await momentsRepo.getMoments(userID: userID)
        listItems = [UserProfileListItemViewModel(userDetails: momentsDetails.userDetails)]
            + momentsDetails.moments.map { MomentListItemViewModel(moment: $0) }
    }
}
