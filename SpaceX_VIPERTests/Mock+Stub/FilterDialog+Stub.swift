//
//  FilterDialog+Stub.swift
//  SpaceX_VIPERTests
//
//  Created by wyn on 2023/3/10.
//

@testable import SpaceX_VIPER

extension FilterDialog {
    static func stub() -> Self {
        FilterDialog(isSuccessLaunchOnly: false,
                     sorting: nil,
                     staticMaxYear: 2020,
                     staticMinYear: 2000,
                     maxYear: 2020,
                     minYear: 2000)
    }
}
