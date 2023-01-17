//
//  APIEndpoints.swift
//  SpaceX_VIPER
//
//  Created by wyn on 2023/1/17.
//

import Foundation

struct APIEndpoints {
    static func getCompany() -> Endpoint<CompanyResponseModel> {
        return Endpoint(path: "v4/company",
                        method: .get)
    }

    static func getLaunchList<T>(request: LaunchRequestModel<T>) -> Endpoint<LaunchResponseModel> {
        
        return Endpoint(path: "v4/launches/query",
                        method: .post,
                        headerParameters: ["Content-Type": "application/json"],
                        bodyParametersEncodable: request)
    }

    static func getRocket(queryID: String) -> Endpoint<RocketResponseModel> {
        return Endpoint(path: "v4/rockets/\(queryID)",
                        method: .get)
    }

    static func getLaunchImage(path: String) -> Endpoint<Data> {
        
        return Endpoint(path: path,
                        isFullPath: true,
                        method: .get,
                        responseDecoder: RawDataResponseDecoder())
    }
}
