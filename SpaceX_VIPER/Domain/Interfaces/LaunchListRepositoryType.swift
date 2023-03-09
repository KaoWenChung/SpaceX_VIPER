//
//  Created by wyn on 2023/1/17.
//

protocol LaunchListRepositoryType {
    func fetchLaunchData<T>(request: LaunchRequest<T>) async throws -> LaunchResponse
}
