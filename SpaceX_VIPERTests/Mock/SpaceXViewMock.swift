//
//  SpaceXViewMock.swift
//  SpaceX_VIPERTests
//
//  Created by wyn on 2023/3/9.
//

@testable import SpaceX_VIPER

final class SpaceXViewMock: SpaceXPresenterToViewProtocol {
    private(set) var isShowLaunching: Bool = false
    private(set) var isConfirmFilter: Bool = false
    private(set) var isSelectSort: Bool = false
    private(set) var isError: Bool = false
    func showLaunches() {
        isShowLaunching = true
    }

    func didConfirmFilter() {
        isConfirmFilter = true
    }

    func didSelectSort() {
        isSelectSort = true
    }

    func showError(_ error: Error) {
        isError = true
    }
}
