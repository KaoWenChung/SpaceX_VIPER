//
//  RocketModel.swift
//  SpaceX_VIPER
//
//  Created by wyn on 2023/1/17.
//

struct RocketResponseModel: Decodable {
    let name: String?
    let type: String?
    
    enum CodingKeys: String, CodingKey {
        case name
        case type
    }
}
