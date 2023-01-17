//
//  FilterDialogViewModel.swift
//  SpaceX_VIPER
//
//  Created by wyn on 2023/1/17.
//

struct FilterDialogViewModel {
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
         oldFilterDialogViewModel: FilterDialogViewModel?) {
        isYearDidChange = oldFilterDialogViewModel?.isYearDidChange ?? false
        self.staticMaxYear = staticMaxYear
        self.staticMinYear = staticMinYear
        maxYear = isYearDidChange ? (oldFilterDialogViewModel?.maxYear ?? staticMaxYear) : staticMaxYear
        minYear = isYearDidChange ? (oldFilterDialogViewModel?.minYear ?? staticMinYear) : staticMinYear
        isPresentSuccessfulLaunchingOnly = oldFilterDialogViewModel?.isPresentSuccessfulLaunchingOnly ?? false
    }
    mutating func setYearIsChanged() {
        isYearDidChange = !(staticMaxYear == maxYear && staticMinYear == minYear)
    }
    mutating func toggleSuccess(_ isOn: Bool) {
        isPresentSuccessfulLaunchingOnly = isOn
    }
}
