//
//  SpaceXPresenterTests.swift
//  SpaceX_VIPERTests
//
//  Created by wyn on 2023/3/5.
//

import XCTest
@testable import SpaceX_VIPER

final class SpaceXPresenterTests: XCTestCase {
    class SpaceXRouterMock: SpaceXRouterType {
        func start(navigationController: UINavigationController) {}
    }

    func testPresenterDidLoadLaunchesUpdatesView() {
        // given
        let interactor = MockSpaceXInteractor(launches: [LaunchCell.stub()], sortOptions: [])
        let presenter = SpaceXPresenter(interactor: interactor, router: SpaceXRouterMock())
        let view = SpaceXViewMock()
        presenter.mainView = view
        
        // when
        presenter.didLoadLaunches()
        
        // then
        XCTAssertEqual(view.isShowLaunching, true)
    }
}
