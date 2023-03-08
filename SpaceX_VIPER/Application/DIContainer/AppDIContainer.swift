//
//  Created by wyn on 2023/1/17.
//

import Foundation

final class AppDIContainer {
    lazy var appConfiguration = AppConfiguration()
    let imageCache = ImageCache()

    // MARK: - Network
    lazy var apiDataTransferService = {
        let config = APIDataNetworkConfig(baseURL: URL(string: appConfiguration.baseURL)!)
        let apiDataNetwork = NetworkService(config: config)
        return DataTransferService(networkService: apiDataNetwork)
    }()

    lazy var imageDataTransferService = {
        let config = APIDataNetworkConfig()
        let imagesDataNetwork = NetworkService(config: config)
        return DataTransferService(networkService: imagesDataNetwork)
    }()

    // MARK: - DIContainers of scenes
    func makeSpaceXSceneDIContainer() -> SpaceXDIContainer {
        let dependencies = SpaceXDIContainer.Dependencies(dataTransferService: apiDataTransferService,
                                                          imageDataTransferService: imageDataTransferService,
                                                          imageCache: imageCache)
        return SpaceXDIContainer(dependencies: dependencies)
    }

}
