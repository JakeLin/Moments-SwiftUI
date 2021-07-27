//
//  MomentsTimelineView.swift
//  Moments
//
//  Created by Jake Lin on 25/7/21.
//

import SwiftUI

struct MomentsTimelineView: View {
    @StateObject private var userDataStore: UserDataStore = .init()
    @StateObject private var viewModel: MomentsTimelineViewModel = .init()
    @State private var isDragging: Bool = false

    var body: some View {
        ScrollView(axes, showsIndicators: true) {
            LazyVStack {
                ForEach (viewModel.listItems, id: \.id) { item in
                    MomentsListItemView(viewModel: item, isDragging: $isDragging)
                }
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .background(Color("background"))
        .ignoresSafeArea(.all)
        .task {
            try? await viewModel.loadItems(userID: userDataStore.currentUser.id)
        }
        .environmentObject(userDataStore)
    }
}

private extension MomentsTimelineView {
    var axes: Axis.Set {
        return isDragging ? [] : .vertical
    }
}

struct MomentsTimelineView_Previews: PreviewProvider {
    static var previews: some View {
        MomentsTimelineView()
    }
}
