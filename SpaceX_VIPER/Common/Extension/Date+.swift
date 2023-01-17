//
//  Date+.swift
//  SpaceX_VIPER
//
//  Created by wyn on 2023/1/17.
//

import Foundation

extension Date {
    func getDaysGap(from fromDate: Date = Date(), to toDate: Date? = nil) -> Int {
        let toDate: Date = toDate == nil ? self : toDate!
        let calendar: Calendar = Calendar.current
        let components = (calendar as NSCalendar).components(.day, from: fromDate, to: toDate, options: [])

        return components.day!
    }
    func getDateString(format: String = "yyyy/MM/dd HH:mm:ss", locale: Locale? = nil, timeZone: TimeZone? = nil) -> String {
        let _format: DateFormatter = DateFormatter()
        _format.dateFormat = format
        _format.locale = locale
        _format.timeZone = timeZone
        let _dateStr: String = "\(_format.string(from: self))"
        return _dateStr
    }
}
