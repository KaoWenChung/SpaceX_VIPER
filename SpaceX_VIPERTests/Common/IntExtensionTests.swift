//
//  IntExtensionTests.swift
//  SpaceX_VIPERTests
//
//  Created by wyn on 2023/3/3.
//

import XCTest
@testable import SpaceX_VIPER

final class IntExtensionTests: XCTestCase {
    func test_unixToDate() {
        // Given
        let unix = 1672531200 // Jan 01 2023 00:00:00 GMT+0000
        let expectedDate = Date(timeIntervalSince1970: TimeInterval(unix))

        // When
        let result = unix.unixToDate

        // Then
        XCTAssertEqual(result, expectedDate)
    }
}
