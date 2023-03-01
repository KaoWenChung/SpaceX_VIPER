//
//  Created by wyn on 2023/1/17.
//

protocol RocketRepositoryType {
    func fetchRocket(queryID: String) async throws -> RocketResponseModel
}
