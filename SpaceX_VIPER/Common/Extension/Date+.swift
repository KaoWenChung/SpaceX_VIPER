//
//  Created by wyn on 2023/1/17.
//

import Foundation

extension Date {
    func getDaysGap(to date: Date = Date()) -> Int {
        let calendar: Calendar = Calendar.current
        let components = (calendar as NSCalendar).components(.day, from: self, to: date, options: [])

        return components.day!
    }
    func getDateString(dateFormat: String = "yyyy/MM/dd HH:mm:ss",
                       locale: Locale? = nil,
                       timeZone: TimeZone? = nil) -> String {
        let format: DateFormatter = DateFormatter()
        format.dateFormat = dateFormat
        format.locale = locale
        format.timeZone = timeZone
        let dateStr: String = "\(format.string(from: self))"
        return dateStr
    }
}
