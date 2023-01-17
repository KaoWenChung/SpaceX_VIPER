//
//  LaunchImagesRepository.swift
//  SpaceX_VIPER
//
//  Created by wyn on 2023/1/17.
//

import UIKit

final class LaunchImagesRepository {
    
    private let dataTransferService: DataTransferServiceType

    init(dataTransferService: DataTransferServiceType) {
        self.dataTransferService = dataTransferService
    }
}

extension LaunchImagesRepository: LaunchImagesRepositoryType {

    func fetchImage(with imagePath: String) async throws -> Data {
        let endpoint = APIEndpoints.getLaunchImage(path: imagePath)
        let (data, _) = try await dataTransferService.request(with: endpoint)
        return data
    }

}
