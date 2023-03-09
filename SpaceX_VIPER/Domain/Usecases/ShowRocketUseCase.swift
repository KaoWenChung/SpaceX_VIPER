//
//  Created by wyn on 2023/1/17.
//

protocol ShowRocketUseCaseType {
    func execute(queryID: String) async throws -> RocketResponse
}

final class ShowRocketUseCase: ShowRocketUseCaseType {
    private let repository: RocketRepositoryType

    init(repository: RocketRepositoryType) {
        self.repository = repository
    }

    func execute(queryID: String) async throws -> RocketResponse {
        return try await repository.fetchRocket(queryID: queryID)
    }
}
