//
//  Created by wyn on 2023/1/17.
//

final class LaunchListRepository {
    private let dataTransferService: DataTransferServiceType

    init(dataTransferService: DataTransferServiceType) {
        self.dataTransferService = dataTransferService
    }
}

extension LaunchListRepository: LaunchListRepositoryType {
    func fetchLaunchData<T>(request: LaunchRequest<T>) async throws -> LaunchResponse {
        let endpoint = APIEndpoints.getLaunchList(request: request)
        let data = try await dataTransferService.request(with: endpoint)
        return data
    }
}
