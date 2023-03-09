//
//  FilterViewMock.swift
//  SpaceX_VIPERTests
//
//  Created by wyn on 2023/3/9.
//

@testable import SpaceX_VIPER

final class FilterViewMock: SpaceXPresenterToFilterViewProtocol {
    private(set) var option: String = ""
    private(set) var model: FilterDialog?
    func updateFilterView(_ model: FilterDialog) {
        self.model = model
    }

    func updateSort(_ option: String) {
        self.option = option
    }
}
