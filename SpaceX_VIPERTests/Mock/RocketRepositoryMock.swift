//
//  RocketRepositoryMock.swift
//  SpaceX_VIPERTests
//
//  Created by wyn on 2023/3/7.
//

import Foundation
@testable import SpaceX_VIPER

class RocketRepositoryMock: RocketRepositoryType {
    let error: Error?
    let response: RocketResponse?
    init(error: Error?,
         response: RocketResponse?) {
        self.error = error
        self.response = response
    }
    func fetchRocket(queryID: String) async throws -> RocketResponse {
        if let error { throw error }
        guard let response else { throw URLError(.badServerResponse) }
        return response
    }
}
