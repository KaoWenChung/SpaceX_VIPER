//
//  Created by wyn on 2023/1/17.
//

struct FilterDialog {
    // Use isYearDidChange to judge whether we need to update maxYear and min Year
    var isYearDidChange: Bool {
        !(staticMaxYear == maxYear && staticMinYear == minYear)
    }
    let isSuccessLaunchOnly: Bool
    let sorting: String?
    let staticMaxYear: Int
    let staticMinYear: Int
    let maxYear: Int
    let minYear: Int
    init(isSuccessLaunchOnly: Bool,
         sorting: String?,
         staticMaxYear: Int,
         staticMinYear: Int,
         maxYear: Int,
         minYear: Int) {
        self.isSuccessLaunchOnly = isSuccessLaunchOnly
        self.sorting = sorting
        self.staticMaxYear = staticMaxYear
        self.staticMinYear = staticMinYear
        self.maxYear = maxYear
        self.minYear = minYear
    }
}
