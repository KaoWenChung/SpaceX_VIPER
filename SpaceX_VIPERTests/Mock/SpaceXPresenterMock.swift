//
//  SpaceXPresenterMock.swift
//  SpaceX_VIPERTests
//
//  Created by wyn on 2023/3/7.
//

import XCTest
@testable import SpaceX_VIPER

class SpaceXPresenterMock: SpaceXListInteractorToPresenterProtocol {
    var error: String?
    var expectation: XCTestExpectation?
    private(set) var isLoadLaunches: Bool = false
    private(set) var isSetFilter: Bool = false
    func didSetFilterModel(_ model: FilterDialogModel) {
        isSetFilter = true
        expectation?.fulfill()
    }
    
    func didLoadLaunches() {
        isLoadLaunches = true
        expectation?.fulfill()
    }
    
    func didLoadLaunchesFailed(_ error: String) {
        self.error = error
        expectation?.fulfill()
    }
}
