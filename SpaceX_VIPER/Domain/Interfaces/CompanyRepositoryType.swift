//
//  CompanyRepositoryType.swift
//  SpaceX_VIPER
//
//  Created by wyn on 2023/1/17.
//

protocol CompanyRepositoryType {
    func fetchCompanyData() async throws -> CompanyResponseModel
}

