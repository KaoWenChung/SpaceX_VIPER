//
//  LaunchListRepositoryType.swift
//  SpaceX_VIPER
//
//  Created by wyn on 2023/1/17.
//

protocol LaunchListRepositoryType {
    func fetchLaunchData<T>(request: LaunchRequestModel<T>) async throws -> (LaunchResponseModel, CancellableType)
}
