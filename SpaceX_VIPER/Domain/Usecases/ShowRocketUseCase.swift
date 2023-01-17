//
//  ShowRocketUseCase.swift
//  SpaceX_VIPER
//
//  Created by wyn on 2023/1/17.
//

protocol ShowRocketUseCaseType {
    func execute(queryID: String) async throws -> RocketResponseModel
}

final class ShowRocketUseCase: ShowRocketUseCaseType {

    private let repository: RocketRepositoryType

    init(repository: RocketRepositoryType) {
        self.repository = repository
    }

    func execute(queryID: String) async throws -> RocketResponseModel {
        return try await repository.fetchRocket(queryID: queryID)
    }
}
