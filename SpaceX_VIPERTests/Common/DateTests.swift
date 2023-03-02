//
//  DateTests.swift
//  SpaceX_VIPERTests
//
//  Created by wyn on 2023/3/2.
//

import XCTest
@testable import SpaceX_VIPER

final class DateExtensionTests: XCTestCase {
    func test_getDaysGap_givenTwoDatesInJanuary_returnsOne() {
        // Given
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        let januaryFirst = formatter.date(from: "2023/01/01 00:00")
        let januarySecond = formatter.date(from: "2023/01/02 00:00")
        
        // When
        let daysGap = januaryFirst?.getDaysGap(to: januarySecond!)
        
        // Then
        XCTAssertEqual(daysGap, 1)
    }
}
