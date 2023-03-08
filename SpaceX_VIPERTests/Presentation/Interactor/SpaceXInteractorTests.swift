//
//  SpaceXInteractorTests.swift
//  SpaceX_VIPERTests
//
//  Created by wyn on 2023/3/5.
//

import XCTest
@testable import SpaceX_VIPER

final class SpaceXInteractorTests: XCTestCase {
    enum MockError: Error {
        case someError
    }
    func testLoadNextPage_ShouldLoadLaunchesAndNotifyPresenter() async {
        // given
        let response = RocketResponseModel(name: "MockName", type: "MockType")
        let rocketRepo = RocketRepositoryMock(error: nil, response: response)
        let rocketUseCase = ShowRocketUseCase(repository: rocketRepo)
        let launchResponse = LaunchResponseModel.stub(docs: [LaunchDocModel.stub()])
        let launchRepo = LaunchRepositoryMock(error: nil, response: launchResponse)
        let launchUseCase = ShowLaunchListUseCase(repository: launchRepo)
        let interactor = SpaceXInteractor(showRocketUseCase: rocketUseCase, showLaunchUseCase: launchUseCase, imageRepository: LaunchImageRepositoryMock())
        let expectation = XCTestExpectation(description: "Should get launches data")
        let presenter = SpaceXPresenterMock()
        presenter.loadLaunchesExpectation = expectation
        interactor.presenter = presenter
        // when
        await interactor.loadNextPage()
        XCTAssertEqual(interactor.launches.count, 1)
        // then
        wait(for: [expectation], timeout: 3.0)
    }

    func testLoadNextPage_whenLaunchesFetchFails_shouldNotifyPresenterOfError() async {
        // given
        let rocketRepo = RocketRepositoryMock(error: nil, response: nil)
        let rocketUseCase = ShowRocketUseCase(repository: rocketRepo)
        let launchRepo = LaunchRepositoryMock(error: MockError.someError, response: nil)
        let launchUseCase = ShowLaunchListUseCase(repository: launchRepo)
        let interactor = SpaceXInteractor(showRocketUseCase: rocketUseCase, showLaunchUseCase: launchUseCase, imageRepository: LaunchImageRepositoryMock())
        let expectation = XCTestExpectation(description: "Should get MockError.someError")
        let presenter = SpaceXPresenterMock()
        presenter.loadLaunchesFailedExpectation = expectation
        interactor.presenter = presenter
        // when
        await interactor.loadNextPage()
        // then
        wait(for: [expectation], timeout: 3.0)
    }

    func testLoadNextPage_whenRocketFetchFails_shouldNotifyPresenterOfError() async {
        // given
        let rocketRepo = RocketRepositoryMock(error: MockError.someError, response: nil)
        let rocketUseCase = ShowRocketUseCase(repository: rocketRepo)
        let launchResponse = LaunchResponseModel.stub(docs: [LaunchDocModel.stub()])
        let launchRepo = LaunchRepositoryMock(error: nil, response: launchResponse)
        let launchUseCase = ShowLaunchListUseCase(repository: launchRepo)
        let interactor = SpaceXInteractor(showRocketUseCase: rocketUseCase, showLaunchUseCase: launchUseCase, imageRepository: LaunchImageRepositoryMock())
        let expectation = XCTestExpectation(description: "Should get MockError.someError")
        let presenter = SpaceXPresenterMock()
        presenter.loadLaunchesFailedExpectation = expectation
        interactor.presenter = presenter
        // when
        await interactor.loadNextPage()
        // then
        wait(for: [expectation], timeout: 3.0)
    }

    func testDidConfirmFilter_shouldsetFilter () async {
        // given
        let response = RocketResponseModel(name: "MockName", type: "MockType")
        let rocketRepo = RocketRepositoryMock(error: nil, response: response)
        let rocketUseCase = ShowRocketUseCase(repository: rocketRepo)
        let launchResponse = LaunchResponseModel.stub(docs: [LaunchDocModel.stub()])
        let launchRepo = LaunchRepositoryMock(error: nil, response: launchResponse)
        let launchUseCase = ShowLaunchListUseCase(repository: launchRepo)
        let interactor = SpaceXInteractor(showRocketUseCase: rocketUseCase, showLaunchUseCase: launchUseCase, imageRepository: LaunchImageRepositoryMock())
        let presenter = SpaceXPresenterMock()
        interactor.presenter = presenter
        // when
        XCTAssertEqual(presenter.isSetFilter, false)
        await interactor.didConfirmFilter(FilterDialogModel(isOnlySuccessfulLaunching: false, sorting: "Ascending", staticMaxYear: 2010, staticMinYear: 2000, maxYear: 2010, minYear: 2000))
        // then
        XCTAssertEqual(presenter.isSetFilter, true)
    }
}
