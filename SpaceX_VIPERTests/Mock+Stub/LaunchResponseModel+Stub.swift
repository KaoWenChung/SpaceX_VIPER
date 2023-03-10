//
//  LaunchResponseModel+Stub.swift
//  SpaceX_VIPERTests
//
//  Created by wyn on 2023/3/7.
//

import Foundation
@testable import SpaceX_VIPER

extension LaunchResponse {
    static func stub(docs: [LaunchDoc]?) -> Self {
        LaunchResponse(docs: docs,
                            hasNextPage: nil,
                            hasPrevPage: nil,
                            limit: nil,
                            nextPage: nil,
                            offset: nil,
                            page: nil,
                            pagingCounter: nil,
                            prevPage: nil,
                            totalDocs: nil,
                            totalPages: nil)
    }
}

extension LaunchDoc {
    static func stub(id: String = "1",
                     success: Bool? = nil) -> Self {
        LaunchDoc(autoUpdate: nil,
                       capsules: nil,
                       cores: nil,
                       dateLocal: nil,
                       datePrecision: nil,
                       dateUnix: nil,
                       dateUtc: nil,
                       details: nil,
                       failures: nil,
                       fairings: nil,
                       flightNumber: nil,
                       id: id,
                       launchLibraryId: nil,
                       launchpad: nil,
                       links: nil,
                       name: nil,
                       net: nil,
                       payloads: nil,
                       rocket: nil,
                       ships: nil,
                       staticFireDateUnix: nil,
                       staticFireDateUtc: nil,
                       success: success,
                       tbd: nil,
                       upcoming: nil,
                       window: nil)
    }
}
