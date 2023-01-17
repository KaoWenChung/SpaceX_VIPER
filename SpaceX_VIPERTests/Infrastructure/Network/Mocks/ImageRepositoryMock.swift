//
//  ImageRepositoryMock.swift
//  SpaceX_VIPERTests
//
//  Created by wyn on 2023/1/17.
//

@testable import SpaceX_VIPER
import UIKit
import XCTest

final class ImageRepositoryMock: LaunchImagesRepositoryType {
    let response: Data?
    let error: Error?
    let expectation: XCTestExpectation?
    init(response: Data?,
         error: Error?,
         expectation: XCTestExpectation?) {
        self.response = response
        self.error = error
        self.expectation = expectation
    }
    func fetchImage(with url: String) async throws -> Data {
        expectation?.fulfill()
        guard let response else {
            throw error ?? ImageError.noResponse
        }
        return response
    }
}
private enum ImageError: Error {
    case noResponse
}
