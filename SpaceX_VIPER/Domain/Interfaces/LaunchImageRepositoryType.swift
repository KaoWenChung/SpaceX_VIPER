//
//  LaunchImagesRepositoryType.swift
//  SpaceX_VIPER
//
//  Created by wyn on 2023/1/17.
//

import UIKit

protocol LaunchImageRepositoryType {
    func fetchImage(with url: String) async throws -> UIImage?
}
