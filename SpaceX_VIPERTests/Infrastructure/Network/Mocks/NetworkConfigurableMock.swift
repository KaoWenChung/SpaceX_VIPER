//
//  NetworkConfigurableMock.swift
//  SpaceX_VIPERTests
//
//  Created by wyn on 2023/1/17.
//

import Foundation
@testable import SpaceX_VIPER

struct NetworkConfigurableMock: NetworkConfigurableType {
    var baseURL: URL? = URL(string: "https://mock.testing.com")
    var headers: [String: String] = [:]
    var queryParameters: [String: String] = [:]
}
