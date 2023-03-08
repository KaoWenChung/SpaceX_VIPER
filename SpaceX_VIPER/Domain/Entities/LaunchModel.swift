//
//  Created by wyn on 2023/1/17.
//

protocol QueryType: Encodable {}

struct LaunchRequestModel<T: QueryType>: Encodable {
    let query: T?
    let options: LaunchOptionRequestModel
}

struct LaunchQuerySuccessDateRequestModel: QueryType {
    let success: Bool = true
    let dateUtc: LaunchQueryDateUTCRequestModel?
    enum CodingKeys: String, CodingKey {
        case success
        case dateUtc = "date_utc"
    }
}

struct LaunchQueryDateRequestModel: QueryType {
    let dateUtc: LaunchQueryDateUTCRequestModel?
    enum CodingKeys: String, CodingKey {
        case dateUtc = "date_utc"
    }
}

struct LaunchQueryDateUTCRequestModel: Encodable {
    let gte: String
    let lte: String
    enum CodingKeys: String, CodingKey {
        case gte = "$gte"
        case lte = "$lte"
    }
}

struct LaunchOptionRequestModel: Encodable {
    let sort: LaunchSortRequestModel?
    let page: Int?
    let limit: Int?
    init(sort: LaunchSortRequestModel? = nil,
         page: Int? = nil,
         limit: Int? = nil) {
        self.sort = sort
        self.page = page
        self.limit = limit
    }
}

struct LaunchSortRequestModel: Encodable {
    enum LaunchSortType: String {
        case desc
        case asc
    }
    let dateUtc: String
    init(sort: LaunchSortType) {
        self.dateUtc = sort.rawValue
    }
    enum CodingKeys: String, CodingKey {
        case dateUtc = "date_utc"
    }
}

struct LaunchResponseModel: Decodable {
    let docs: [LaunchDocModel]?
    let hasNextPage: Bool?
    let hasPrevPage: Bool?
    let limit: Int?
    let nextPage: Int?
    let offset: Int?
    let page: Int?
    let pagingCounter: Int?
    let prevPage: Int?
    let totalDocs: Int?
    let totalPages: Int?

    enum CodingKeys: String, CodingKey {
        case docs
        case hasNextPage
        case hasPrevPage
        case limit
        case nextPage
        case offset
        case page
        case pagingCounter
        case prevPage
        case totalDocs
        case totalPages
    }
}

struct LaunchDocModel: Decodable {
    let autoUpdate: Bool?
    let capsules: [String]?
    let cores: [LaunchCoreModel]?
    let dateLocal: String?
    let datePrecision: String?
    let dateUnix: Int?
    let dateUtc: String?
    let details: String?
    let failures: [LaunchFailureModel]?
    let fairings: LaunchFairingModel?
    let flightNumber: Int?
    let id: String?
    let launchLibraryId: String?
    let launchpad: String?
    let links: LaunchLinkModel?
    let name: String?
    let net: Bool?
    let payloads: [String]?
    let rocket: String?
    let ships: [String]?
    let staticFireDateUnix: Int?
    let staticFireDateUtc: String?
    let success: Bool?
    let tbd: Bool?
    let upcoming: Bool?
    let window: Int?

    enum CodingKeys: String, CodingKey {
        case autoUpdate = "auto_update"
        case capsules
        case cores
        case dateLocal = "date_local"
        case datePrecision = "date_precision"
        case dateUnix = "date_unix"
        case dateUtc = "date_utc"
        case details
        case failures
        case fairings
        case flightNumber = "flight_number"
        case id
        case launchLibraryId = "launch_library_id"
        case launchpad
        case links
        case name
        case net
        case payloads
        case rocket
        case ships
        case staticFireDateUnix = "static_fire_date_unix"
        case staticFireDateUtc = "static_fire_date_utc"
        case success
        case tbd
        case upcoming
        case window
    }
}

struct LaunchFailureModel: Decodable {
    let time: Int?
    let altitude: Int?
    let reason: String?

    enum CodingKeys: String, CodingKey {
        case time
        case altitude
        case reason
    }
}

struct LaunchLinkModel: Decodable {
    let article: String?
    let flickr: LaunchFlickrModel?
    let patch: LaunchPatchModel?
    let presskit: String?
    let reddit: LaunchRedditModel?
    let webcast: String?
    let wikipedia: String?
    let youtubeId: String?

    enum CodingKeys: String, CodingKey {
        case article
        case flickr
        case patch
        case presskit
        case reddit
        case webcast
        case wikipedia
        case youtubeId = "youtube_id"
    }
}

struct LaunchRedditModel: Decodable {
    let campaign: String?
    let launch: String?
    let media: String?
    let recovery: String?

    enum CodingKeys: String, CodingKey {
        case campaign
        case launch
        case media
        case recovery
    }
}

struct LaunchPatchModel: Decodable {
    let large: String?
    let small: String?

    enum CodingKeys: String, CodingKey {
        case large
        case small
    }
}

struct LaunchFlickrModel: Decodable {
    let original: [String]?
    let small: [String]?

    enum CodingKeys: String, CodingKey {
        case original
        case small
    }
}

struct LaunchFairingModel: Decodable {
    let recovered: Bool?
    let recoveryAttempt: Bool?
    let reused: Bool?
    let ships: [String]?

    enum CodingKeys: String, CodingKey {
        case recovered
        case recoveryAttempt = "recovery_attempt"
        case reused
        case ships
    }
}

struct LaunchCoreModel: Decodable {
    let core: String?
    let flight: Int?
    let gridfins: Bool?
    let landingAttempt: Bool?
    let landingSuccess: Bool?
    let landingType: String?
    let landpad: String?
    let legs: Bool?
    let reused: Bool?

    enum CodingKeys: String, CodingKey {
        case core
        case flight
        case gridfins
        case landingAttempt = "landing_attempt"
        case landingSuccess = "landing_success"
        case landingType = "landing_type"
        case landpad
        case legs
        case reused
    }
}
