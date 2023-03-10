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

    func testPresenterShowsError_whenLoadingLaunchesFails() {
        // given
        let interactor = MockSpaceXInteractor(launches: [LaunchCell.stub()], sortOptions: [])
        let presenter = SpaceXPresenter(interactor: interactor, router: SpaceXRouterMock())
        let view = SpaceXViewMock()
        presenter.mainView = view

        // when
        presenter.didLoadLaunchesFailed(ErrorMock.someError)

        // then
        XCTAssertEqual(view.isError, true)
    }

    func testPresenterDidSetFilter_updateFilterView() {
        // given
        let interactor = MockSpaceXInteractor(launches: [LaunchCell.stub()], sortOptions: [])
        let presenter = SpaceXPresenter(interactor: interactor, router: SpaceXRouterMock())
        let filterView = FilterViewMock()
        presenter.filterView = filterView

        // when
        presenter.didSetFilterModel(FilterDialog.stub())

        // then
        XCTAssertEqual(filterView.model?.isSuccessLaunchOnly, false)
        XCTAssertEqual(filterView.model?.staticMaxYear, 2020)
        XCTAssertEqual(filterView.model?.staticMinYear, 2000)
        XCTAssertEqual(filterView.model?.maxYear, 2020)
        XCTAssertEqual(filterView.model?.minYear, 2000)
    }
}
