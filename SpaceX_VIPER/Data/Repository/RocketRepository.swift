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
    func fetchRocket(queryID: String) async throws -> RocketResponse {
        let endpoint = APIEndpoints.getRocket(queryID: queryID)
        let data = try await dataTransferService.request(with: endpoint)
        return data
    }
}
