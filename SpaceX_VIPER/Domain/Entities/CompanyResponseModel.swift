//
//  CompanyResponseModel.swift
//  SpaceX_VIPER
//
//  Created by wyn on 2023/1/17.
//

struct CompanyResponseModel : Codable {

    let ceo : String?
    let coo : String?
    let cto : String?
    let ctoPropulsion : String?
    let employees : Int?
    let founded : Int?
    let founder : String?
    let headquarters : CompanyHeadquarterModel?
    let id : String?
    let launchSites : Int?
    let links : CompanyLinkModel?
    let name : String?
    let summary : String?
    let testSites : Int?
    let valuation : Int?
    let vehicles : Int?


    enum CodingKeys: String, CodingKey {
        case ceo
        case coo
        case cto
        case ctoPropulsion = "cto_propulsion"
        case employees
        case founded
        case founder
        case headquarters
        case id
        case launchSites = "launch_sites"
        case links
        case name
        case summary
        case testSites = "test_sites"
        case valuation
        case vehicles
    }

}

struct CompanyLinkModel : Codable {
    
    let elonTwitter : String?
    let flickr : String?
    let twitter : String?
    let website : String?
    
    
    enum CodingKeys: String, CodingKey {
        case elonTwitter = "elon_twitter"
        case flickr
        case twitter
        case website
    }
}

struct CompanyHeadquarterModel : Codable {

    let address : String?
    let city : String?
    let state : String?

    enum CodingKeys: String, CodingKey {
        case address
        case city
        case state
    }
}
