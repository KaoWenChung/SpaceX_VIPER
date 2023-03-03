//
//  UITableViewCellExtensionTests.swift
//  SpaceX_VIPERTests
//
//  Created by wyn on 2023/3/3.
//

import XCTest
@testable import SpaceX_VIPER

final class UITableViewCellExtensionTests: XCTestCase {
    class MockUITableViewCell: UITableViewCell {}

    func test_name() {
        let name = MockUITableViewCell.name
        XCTAssertEqual(name, "MockUITableViewCell")
    }
}
