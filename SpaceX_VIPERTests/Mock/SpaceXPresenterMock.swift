//
//  SpaceXPresenterMock.swift
//  SpaceX_VIPERTests
//
//  Created by wyn on 2023/3/7.
//

import XCTest
@testable import SpaceX_VIPER

class SpaceXPresenterMock: SpaceXListInteractorToPresenterProtocol {
    var error: Error?
    var loadLaunchesExpectation: XCTestExpectation?
    var loadLaunchesFailedExpectation: XCTestExpectation?
    private(set) var isSetFilter: Bool = false
    func didSetFilterModel(_ model: FilterDialogModel) {
        isSetFilter = true
    }
    
    func didLoadLaunches() {
        loadLaunchesExpectation?.fulfill()
    }
    
    func didLoadLaunchesFailed(_ error: Error) {
        self.error = error
        loadLaunchesFailedExpectation?.fulfill()
    }
}
