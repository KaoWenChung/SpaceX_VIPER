//
//  LaunchRepositoryMock.swift
//  SpaceX_VIPERTests
//
//  Created by wyn on 2023/3/7.
//

import Foundation
@testable import SpaceX_VIPER

final class LaunchRepositoryMock: LaunchListRepositoryType {
    let error: Error?
    let response: LaunchResponse?
    init(error: Error?,
         response: LaunchResponse?) {
        self.error = error
        self.response = response
    }
    func fetchLaunchData<T: QueryType>(request: LaunchRequest<T>) async throws -> LaunchResponse {
        if let error { throw error }
        guard let response else { throw URLError(.badServerResponse) }
        return response
    }
}
