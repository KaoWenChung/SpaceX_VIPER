//
//  LaunchImagesRepositoryType.swift
//  SpaceX_VIPER
//
//  Created by wyn on 2023/1/17.
//

import Foundation

protocol LaunchImagesRepositoryType {
    func fetchImage(with url: String) async throws -> Data
}
