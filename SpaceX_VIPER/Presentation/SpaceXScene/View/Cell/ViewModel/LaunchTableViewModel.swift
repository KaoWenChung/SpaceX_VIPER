//
//  LaunchTableViewModel.swift
//  SpaceX_VIPER
//
//  Created by wyn on 2023/1/17.
//

struct LaunchTableViewModel {
    let mission: String
    let date: String?
    let imageURL: String
    let days: String?
    let isSuccess: Bool?
    let videoLink: String?
    let wikiLink: String?
    let articleLink: String?
    
    private(set) var rocket: String? = nil
    
    init(_ launchData: LaunchDocModel) {
        mission = "Misson: \(launchData.name ?? "")"

        if let dateUnix = launchData.dateUnix {
            let dateString = dateUnix.unixToDate.getDateString(format: "MM/dd")
            let timeString = dateUnix.unixToDate.getDateString(format: "HH:mm")
            self.date = "Date: \(dateString) at \(timeString)"

            let daysInt = dateUnix.unixToDate.getDaysGap()
            let absDaysInt = abs(daysInt)
            if daysInt > 0 {
                days = "From: \(absDaysInt.description) days"
            } else {
                days = "Since: \(absDaysInt.description) days"
            }
        } else {
            date = nil
            days = nil
        }
        imageURL = launchData.links?.patch?.small ?? ""
        isSuccess = launchData.success
        articleLink = launchData.links?.article
        wikiLink = launchData.links?.wikipedia
        videoLink = launchData.links?.webcast
    }
    
    mutating func updateRocket(_ rocket: RocketResponseModel?) {
        if let name = rocket?.name, let type = rocket?.type {
            self.rocket = "\(name)/ \(type)"
        }
    }
}
