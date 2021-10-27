//
//  MomentsListItemView.swift
//  Moments
//
//  Created by Jake Lin on 25/7/21.
//

import SwiftUI

struct MomentsListItemView: View {
    let viewModel: ListItemViewModelType
    @Binding var isDragging: Bool

    var body: some View {
        if let viewModel = viewModel as? UserProfileListItemViewModel {
            UserProfileListItemView(viewModel: viewModel, isDragging: $isDragging)
        } else if let viewModel = viewModel as? MomentListItemViewModel {
            MomentListItemView(viewModel: viewModel)
        }
    }
}
