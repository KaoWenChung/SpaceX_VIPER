//
//  FilterDialogInteractor.swift
//  SpaceX_VIPER
//
//  Created by wyn on 2023/1/17.
//

struct FilterDialogModel {
    // Use isYearDidChange to judge whether we need to update maxYear and min Year
    var isYearDidChange: Bool {
        !(staticMaxYear == maxYear && staticMinYear == minYear)
    }
    let isOnlySuccessfulLaunching: Bool
    let sorting: String?
    let staticMaxYear: Int
    let staticMinYear: Int
    let maxYear: Int
    let minYear: Int
    init(isOnlySuccessfulLaunching: Bool,
         sorting: String?,
         staticMaxYear: Int,
         staticMinYear: Int,
         maxYear: Int,
         minYear: Int) {
        self.isOnlySuccessfulLaunching = isOnlySuccessfulLaunching
        self.sorting = sorting
        self.staticMaxYear = staticMaxYear
        self.staticMinYear = staticMinYear
        self.maxYear = maxYear
        self.minYear = minYear
    }
}
