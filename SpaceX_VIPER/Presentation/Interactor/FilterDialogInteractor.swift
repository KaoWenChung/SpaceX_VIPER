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
    let isPresentSuccessfulLaunchingOnly: Bool
    let isAscending: Bool
    let staticMaxYear: Int
    let staticMinYear: Int
    let maxYear: Int
    let minYear: Int
    init(isPresentSuccessfulLaunchingOnly: Bool,
         isAscending: Bool,
         staticMaxYear: Int,
         staticMinYear: Int,
         maxYear: Int,
         minYear: Int) {
        self.isPresentSuccessfulLaunchingOnly = isPresentSuccessfulLaunchingOnly
        self.isAscending = isAscending
        self.staticMaxYear = staticMaxYear
        self.staticMinYear = staticMinYear
        self.maxYear = maxYear
        self.minYear = minYear
    }
}
