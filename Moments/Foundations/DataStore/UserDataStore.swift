//
//  UserDataStore.swift
//  Moments
//
//  Created by Jake Lin on 25/7/21.
//

import Foundation

protocol UserType {
    var id: String { get }
}

struct User: UserType {
    let id: String
}

final class UserDataStore: ObservableObject {
    // Hardcode the user id to 0
    @Published var currentUser: UserType = User(id: "0")
}
