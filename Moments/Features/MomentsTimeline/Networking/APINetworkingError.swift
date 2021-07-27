//
//  APINetworkingError.swift
//  APINetworkingError
//
//  Created by Jake Lin on 27/7/21.
//

import Foundation

enum APINetworkingError: Error {
    case invalidURL
    case invalidParameter
    case networkURLError
    case networkStatusError(Int)
    case invalidResponseJSON
    case noData
}
