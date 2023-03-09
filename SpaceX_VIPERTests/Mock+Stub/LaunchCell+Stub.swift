//
//  LaunchCell+Stub.swift
//  SpaceX_VIPERTests
//
//  Created by wyn on 2023/3/9.
//

@testable import SpaceX_VIPER

extension LaunchCell {
    static func stub() -> Self {
        LaunchCell(LaunchDoc.stub(),
                   imageRepository: LaunchImageRepositoryMock())
    }
}

extension LaunchDoc {
    static func stub() -> Self {
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
                  id: nil,
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
                  success: nil,
                  tbd: nil,
                  upcoming: nil,
                  window: nil)
    }
}
