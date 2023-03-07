//
//  LaunchRepositoryMock.swift
//  SpaceX_VIPERTests
//
//  Created by wyn on 2023/3/7.
//

import Foundation
@testable import SpaceX_VIPER

class LaunchRepositoryMock: LaunchListRepositoryType {
    let error: Error?
    let response: LaunchResponseModel?
    init(error: Error?,
         response: LaunchResponseModel?) {
        self.error = error
        self.response = response
    }
    func fetchLaunchData<T: QueryType>(request: LaunchRequestModel<T>) async throws -> LaunchResponseModel {
        if let error { throw error }
        guard let response else { throw URLError(.badServerResponse) }
        return response
    }
}
