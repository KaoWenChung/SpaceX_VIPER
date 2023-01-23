//
//  FilterDialogInteractor.swift
//  SpaceX_VIPER
//
//  Created by wyn on 2023/1/17.
//

struct FilterDialogInteractor {
    // Use isYearDidChange to judge whether we need to update maxYear and min Year
    private(set) var isYearDidChange: Bool = false
    var isPresentSuccessfulLaunchingOnly: Bool
    var isAscending: Bool = true
    let staticMaxYear: Int
    let staticMinYear: Int
    var maxYear: Int
    var minYear: Int
    init(staticMaxYear: Int,
         staticMinYear: Int,
         oldFilterDialogModel: FilterDialogInteractor?) {
        isYearDidChange = oldFilterDialogModel?.isYearDidChange ?? false
        self.staticMaxYear = staticMaxYear
        self.staticMinYear = staticMinYear
        maxYear = isYearDidChange ? (oldFilterDialogModel?.maxYear ?? staticMaxYear) : staticMaxYear
        minYear = isYearDidChange ? (oldFilterDialogModel?.minYear ?? staticMinYear) : staticMinYear
        isPresentSuccessfulLaunchingOnly = oldFilterDialogModel?.isPresentSuccessfulLaunchingOnly ?? false
    }
    mutating func setYearIsChanged() {
        isYearDidChange = !(staticMaxYear == maxYear && staticMinYear == minYear)
    }
    mutating func toggleSuccess(_ isOn: Bool) {
        isPresentSuccessfulLaunchingOnly = isOn
    }
}
