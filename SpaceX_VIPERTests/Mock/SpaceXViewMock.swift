//
//  SpaceXViewMock.swift
//  SpaceX_VIPERTests
//
//  Created by wyn on 2023/3/9.
//

@testable import SpaceX_VIPER

final class SpaceXViewMock: SpaceXPresenterToViewProtocol {
    private(set) var isShowLaunching: Bool = false
    func showLaunches() {
        isShowLaunching = true
    }

    func didConfirmFilter() {
    }

    func didSelectSort() {
    }

    func showError(_ error: String) {
    }
}
