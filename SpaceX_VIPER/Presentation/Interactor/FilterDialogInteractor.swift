//
//  FilterDialogInteractor.swift
//  SpaceX_VIPER
//
//  Created by wyn on 2023/1/17.
//

struct FilterDialogModel {
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
