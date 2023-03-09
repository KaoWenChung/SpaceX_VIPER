//
//  Created by wyn on 2023/1/17.
//

protocol ShowLaunchListUseCaseType {
    func execute<T>(request: LaunchRequest<T>) async throws -> LaunchResponse
}

final class ShowLaunchListUseCase: ShowLaunchListUseCaseType {
    private let repository: LaunchListRepositoryType

    init(repository: LaunchListRepositoryType) {

        self.repository = repository
    }

    func execute<T>(request: LaunchRequest<T>) async throws -> LaunchResponse {
        return try await repository.fetchLaunchData(request: request)
    }
}
