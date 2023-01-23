//
//  LaunchImagesRepository.swift
//  SpaceX_VIPER
//
//  Created by wyn on 2023/1/17.
//

import UIKit

final class LaunchImageRepository {
    private let dataTransferService: DataTransferServiceType
    private let imageCache: ImageCacheType

    init(dataTransferService: DataTransferServiceType,
         imageCache: ImageCacheType) {
        self.dataTransferService = dataTransferService
        self.imageCache = imageCache
    }
}

extension LaunchImageRepository: LaunchImageRepositoryType {
    func fetchImage(with imagePath: String) async throws -> UIImage? {
        if let image = imageCache[imagePath] {
            return image
        }
        let endpoint = APIEndpoints.getLaunchImage(path: imagePath)
        let data = try await dataTransferService.request(with: endpoint)
        let imageResult = UIImage(data: data)
        imageCache.insertImage(imageResult, for: imagePath)
        return imageResult
    }
}
