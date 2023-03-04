//
//  Created by wyn on 2023/1/17.
//

struct LaunchCellModel {
    private enum LaunchCellModelString: LocalizedStringType {
        case name
        case date
        case from
        case since
    }
    let imageRepository: LaunchImageRepositoryType
    let name: String
    let date: String?
    let imageURL: String
    let days: String?
    let isSuccess: Bool?
    
    private(set) var rocket: String? = nil
    
    init(_ launchData: LaunchDocModel,
         imageRepository: LaunchImageRepositoryType) {
        self.imageRepository = imageRepository
        name = String(format: LaunchCellModelString.name.text, launchData.name ?? "")

        if let dateUnix = launchData.dateUnix {
            let dateString = dateUnix.unixToDate.getDateString(format: "MM/dd")
            let timeString = dateUnix.unixToDate.getDateString(format: "HH:mm")
            self.date = String(format: LaunchCellModelString.date.text, dateString, timeString)

            let daysInt = dateUnix.unixToDate.getDaysGap()
            let absDaysInt = abs(daysInt)
            if daysInt > 0 {
                days = String(format: LaunchCellModelString.from.text, absDaysInt.description)
            } else {
                days = String(format: LaunchCellModelString.since.text, absDaysInt.description)
            }
        } else {
            date = nil
            days = nil
        }
        imageURL = launchData.links?.patch?.small ?? ""
        isSuccess = launchData.success
    }
    
    mutating func updateRocket(_ rocket: RocketResponseModel?) {
        if let name = rocket?.name, let type = rocket?.type {
            self.rocket = "\(name)/ \(type)"
        }
    }
}
