//
//  LaunchResponseModel+Stub.swift
//  SpaceX_VIPERTests
//
//  Created by wyn on 2023/3/7.
//

import Foundation
@testable import SpaceX_VIPER

extension LaunchResponseModel {
    static func stub(docs: [LaunchDocModel]?) -> Self {
        LaunchResponseModel(docs: docs,
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
