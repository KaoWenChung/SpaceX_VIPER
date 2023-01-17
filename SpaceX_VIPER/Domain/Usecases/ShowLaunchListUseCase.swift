//
//  ShowLaunchListUseCase.swift
//  SpaceX_VIPER
//
//  Created by wyn on 2023/1/17.
//

protocol ShowLaunchListUseCaseType {
    func execute<T>(request: LaunchRequestModel<T>) async throws -> (LaunchResponseModel, CancellableType)
}

final class ShowLaunchListUseCase: ShowLaunchListUseCaseType {

    private let repository: LaunchListRepositoryType

    init(repository: LaunchListRepositoryType) {

        self.repository = repository
    }

    func execute<T>(request: LaunchRequestModel<T>) async throws -> (LaunchResponseModel, CancellableType) {
        return try await repository.fetchLaunchData(request: request)
    }
}
