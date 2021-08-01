//
//  MomentListItemView.swift
//  Moments
//
//  Created by Jake Lin on 25/7/21.
//

import SwiftUI

private struct LikeToggleBackground<S: Shape>: View {
    var isHighlighted: Bool
    var shape: S

    var body: some View {
        ZStack {
            if isHighlighted {
                shape
                    .fill(LinearGradient(Color("likeButtonFillEnd"), Color("likeButtonFillStart")))
                    .overlay(shape.stroke(LinearGradient(Color("likeButtonFillStart"), Color("likeButtonFillEnd")), lineWidth: 2))
                    .shadow(color: Color("likeButtonStart"), radius: 5, x: 5, y: 5)
                    .shadow(color: Color("likeButtonEnd"), radius: 5, x: -5, y: -5)
            } else {
                shape
                    .fill(LinearGradient(Color("likeButtonFillStart"), Color("likeButtonFillEnd")))
                    .overlay(shape.stroke(LinearGradient(Color("likeButtonFillStart"), Color("likeButtonFillEnd")), lineWidth: 2))
                    .shadow(color: Color("likeButtonStart"), radius: 5, x: 5, y: 5)
                    .shadow(color: Color("likeButtonEnd"), radius: 5, x: -5, y: -5)
            }
        }
    }
}

private struct LikeToggleStyle: ToggleStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        Button(action: {
            configuration.isOn.toggle()
        }, label: {
            configuration.label
                .padding(8)
                .contentShape(Circle())
        })
        .background(
            LikeToggleBackground(isHighlighted: configuration.isOn, shape: Circle())
        )
    }
}

struct MomentListItemView: View {
    @ObservedObject private var viewModel: MomentListItemViewModel
    @EnvironmentObject var userDataStore: UserDataStore

    @State private var isLiked: Bool

    init(viewModel: MomentListItemViewModel) {
        self.viewModel = viewModel
        _isLiked = State(initialValue: viewModel.isLiked)
    }

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            HStack(alignment: .top, spacing: 18) {
                AsyncImage(url: viewModel.userAvatarURL) { phase in
                    if let image = phase.image {
                        image.resizable()
                    } else if phase.error != nil {
                        // Indicates an error.
                        Color.red
                    } else {
                        // Acts as a placeholder.
                        ProgressView()
                    }
                }
                .clipShape(Circle())
                .frame(width: 44, height: 44)
                .shadow(color: Color.primary.opacity(0.15), radius: 5, x: 0, y: 2)
                .padding(.leading, 18)

                VStack(alignment: .leading) {
                    Text(viewModel.userName)
                        .font(.subheadline)
                        .foregroundColor(.primary)

                    if let title = viewModel.title {
                        Text(title)
                            .font(.body)
                            .foregroundColor(Color.secondary)
                    }

                    if let photoURL = viewModel.photoURL {
                        AsyncImage(url: photoURL) { phase in
                            if let image = phase.image {
                                image.resizable()
                            } else if phase.error != nil {
                                // Indicates an error.
                                Color.red
                            } else {
                                // Acts as a placeholder.
                                ProgressView()
                            }
                        }.frame(width: 240, height: 120)
                    }

                    if let postDateDescription = viewModel.postDateDescription {
                        Text(postDateDescription)
                            .font(.footnote)
                            .foregroundColor(Color.secondary)
                    }

                    if let likes = viewModel.likes, !likes.isEmpty {
                        HStack {
                            Image(systemName: "heart")
                                .foregroundColor(.secondary)
                            ForEach(likes, id: \.absoluteURL) {
                                AsyncImage(url: $0) { phase in
                                    if let image = phase.image {
                                        image.resizable()
                                    } else if phase.error != nil {
                                        // Indicates an error.
                                        Color.red
                                    } else {
                                        // Acts as a placeholder.
                                        ProgressView()
                                    }
                                }
                                .frame(width: 20, height: 20)
                                .clipShape(Circle())
                                .shadow(color: Color.primary.opacity(0.15), radius: 3, x: 0, y: 2)
                            }
                        }
                    }
                }
                Spacer()
            }

            Toggle(isOn: $isLiked) {
                withAnimation(.easeIn) {
                    Image(systemName: "heart.fill")
                        .foregroundColor(isLiked == true ? Color("likeButtonSelected") : Color("likeButtonNotSelected"))
                }
            }
            .toggleStyle(LikeToggleStyle())
            .padding(.trailing, 18)
            .onChange(of: isLiked, perform: { isOn in
                guard isLiked == isOn else { return }
                Task {
                    if isOn {
                        try? await viewModel.like(from: userDataStore.currentUser.id)
                    } else {
                        try? await viewModel.unlike(from: userDataStore.currentUser.id)
                    }
                }
            })
        }
        .frame(maxWidth:.infinity)
        .padding(EdgeInsets(top: 18, leading: 0, bottom: 18, trailing: 0))
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
        .shadow(color: Color.black.opacity(0.15), radius: 20, x: 0, y: 20)
        .padding(.horizontal)
    }
}

private extension LinearGradient {
    init(_ colors: Color...) {
        self.init(gradient: Gradient(colors: colors), startPoint: .topLeading, endPoint: .bottomTrailing)
    }
}
