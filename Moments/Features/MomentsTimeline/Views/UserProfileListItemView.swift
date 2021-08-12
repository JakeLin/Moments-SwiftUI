//
//  UserProfileListItemView.swift
//  Moments
//
//  Created by Jake Lin on 25/7/21.
//

import SwiftUI

struct UserProfileListItemView: View {
    let viewModel: UserProfileListItemViewModel
    @Binding var isDragging: Bool

    @State private var viewSize: CGSize = .zero

    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Text(viewModel.name)
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding(.trailing, 10)
                AsyncImage(url: viewModel.avatarURL) { phase in
                    if let image = phase.image {
                        image.resizable()
                            .aspectRatio(contentMode: .fill)
                    } else if phase.error != nil {
                        // Indicates an error.
                        Color.red
                    } else {
                        // Acts as a placeholder.
                        ProgressView()
                    }
                }
                .frame(width: 80, height: 80, alignment: .center)
                .clipShape(Circle())
            }
            .padding(.trailing, 10)
            .padding(.bottom, 10)
        }
        .frame(height: 350)
        .frame(maxWidth: .infinity)
        .background(
            ZStack {
                Image(uiImage: #imageLiteral(resourceName: "Blob"))
                    .offset(x: -200, y: -200)
                    .rotationEffect(Angle(degrees: 450))
                    .blendMode(.plusDarker)
                Image(uiImage: #imageLiteral(resourceName: "Blob"))
                    .offset(x: -200, y: -250)
                    .rotationEffect(Angle(degrees: 360), anchor: .leading)
                    .blendMode(.overlay)
            }
        )
        .background(
            AsyncImage(url: viewModel.backgroundImageURL) { phase in
                if let image = phase.image {
                    image.resizable()
                } else if phase.error != nil {
                    // Indicates an error.
                    Color.red
                } else {
                    // Acts as a placeholder.
                    ProgressView()
                }
            }.offset(x: viewSize.width / 20, y: viewSize.height / 20)
        )
        .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
        .scaleEffect(isDragging ? 0.9 : 1)
        .animation(.timingCurve(0.2, 0.8, 0.2, 1, duration: 0.8), value: isDragging)
        .rotation3DEffect(Angle(degrees: 5), axis: (x: viewSize.width, y: viewSize.height, z: 0))
        .gesture(
            DragGesture(minimumDistance: 0).onChanged({ value in
                self.isDragging = true
                self.viewSize = value.translation
            }).onEnded({ _ in
                self.isDragging = false
                self.viewSize = .zero
            })
        )
    }
}
