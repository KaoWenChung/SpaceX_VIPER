//
//  LaunchImageRepositoryMock.swift
//  SpaceX_VIPERTests
//
//  Created by wyn on 2023/3/7.
//

@testable import SpaceX_VIPER
import UIKit

class LaunchImageRepositoryMock: LaunchImageRepositoryType {
    let error: Error?
    let response: UIImage?
    init(error: Error? = nil,
         response: UIImage? = nil) {
        self.error = error
        self.response = response
    }
    func fetchImage(with url: String) async throws -> UIImage? {
        if let error { throw error }
        guard let response else { throw URLError(.badServerResponse) }
        return response
    }
}
