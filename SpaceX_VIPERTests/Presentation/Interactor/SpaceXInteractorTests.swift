//
//  SpaceXInteractorTests.swift
//  SpaceX_VIPERTests
//
//  Created by wyn on 2023/3/5.
//

import XCTest
@testable import SpaceX_VIPER

final class SpaceXInteractorTests: XCTestCase {
    func testLaunches() {
        // given
        let response = RocketResponseModel(name: "MockName", type: "MockType")
        let rocketRepo = RocketRepositoryMock(error: nil, response: response)
        let rocketUseCase = ShowRocketUseCase(repository: rocketRepo)
        let launchResponse = LaunchResponseModel.stub(docs: nil)
        let launchRepo = LaunchRepositoryMock(error: nil, response: launchResponse)
        let launchUseCase = ShowLaunchListUseCase(repository: launchRepo)
        let interactor = SpaceXInteractor(showRocketUseCase: rocketUseCase, showLaunchUseCase: launchUseCase, imageRepository: LaunchImageRepositoryMock())
        let expectation = XCTestExpectation(description: "Should get launches data")
        let presenter = SpaceXPresenterMock()
        presenter.expectation = expectation
        interactor.presenter = presenter
        // when
        interactor.loadNextPage()
        // then
        wait(for: [expectation], timeout: 3.0)
    }
}
