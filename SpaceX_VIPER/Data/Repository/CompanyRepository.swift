//
//  CompanyRepository.swift
//  SpaceX_VIPER
//
//  Created by wyn on 2023/1/17.
//

final class CompanyRepository {

    private let dataTransferService: DataTransferServiceType

    init(dataTransferService: DataTransferServiceType) {
        self.dataTransferService = dataTransferService
    }
}

extension CompanyRepository: CompanyRepositoryType {
    func fetchCompanyData() async throws -> CompanyResponseModel {
        let endpoint = APIEndpoints.getCompany()
        let (data, _) = try await dataTransferService.request(with: endpoint)
        return data
    }
}
