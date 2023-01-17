//
//  Int+.swift
//  SpaceX_VIPER
//
//  Created by wyn on 2023/1/17.
//

import Foundation

extension Int {
    var unixToDate: Date {
        let myTimeInterval = TimeInterval(self)
        let time = Date(timeIntervalSince1970: myTimeInterval)
        return time
    }
}

