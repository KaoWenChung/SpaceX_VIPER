//
//  ShowCompanyUseCase.swift
//  SpaceX_VIPER
//
//  Created by wyn on 2023/1/17.
//

protocol ShowCompanyUseCaseType {
    func execute() async throws -> CompanyResponseModel
}

final class ShowCompanyUseCase: ShowCompanyUseCaseType {

    private let repository: CompanyRepositoryType

    init(repository: CompanyRepositoryType
         
) {

        self.repository = repository
    }

    func execute() async throws -> CompanyResponseModel {
        return try await repository.fetchCompanyData()
    }
}

