//
//  Created by wyn on 2023/1/17.
//

final class AppConfiguration {
    // Define environment
    enum Environment {
        case debug
        case release
    }

    let current: Environment
    private(set) var baseURL: String!

    init() {
        #if DEBUG
        current = .debug
        #elseif RELEASE
        current = .release
        #endif
        baseURL = getBaseURL()
    }

    private func getBaseURL() -> String {
        #if DEBUG
        return "https://api.spacexdata.com/"
        #elseif RELEASE
        return "https://api.spacexdata.com/"
        #endif
    }
}
