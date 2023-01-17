//
//  RocketRepository.swift
//  SpaceX_VIPER
//
//  Created by wyn on 2023/1/17.
//

final class RocketRepository {

    private let dataTransferService: DataTransferServiceType

    init(dataTransferService: DataTransferServiceType) {
        self.dataTransferService = dataTransferService
    }
}

extension RocketRepository: RocketRepositoryType {
    func fetchRocket(queryID: String) async throws -> RocketResponseModel {
        let endpoint = APIEndpoints.getRocket(queryID: queryID)
        let (data, _) = try await dataTransferService.request(with: endpoint)
        return data
    }
}
