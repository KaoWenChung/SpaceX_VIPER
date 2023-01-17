//
//  NetworkService.swift
//  SpaceX_VIPER
//
//  Created by wyn on 2023/1/17.
//

import Foundation

public typealias URLTask = Task<(Data, URLResponse), Error>

public enum NetworkError: Error {
    case error(statusCode: Int, data: Data?)
    case notConnected
    case cancelled
    case generic(Error)
    case urlGeneration
}

public protocol NetworkServiceType {
    @discardableResult
    func request(endpoint: RequestableType) throws -> URLTask
}

public protocol NetworkSessionManagerType {
    typealias DataResponse = (Data, URLResponse)
    
    func request(_ request: URLRequest) async throws -> DataResponse
}

public protocol NetworkErrorLoggerType {
    func log(request: URLRequest)
    func log(responseData data: Data?, response: URLResponse?)
    func log(error: Error)
}

// MARK: - Implementation

public struct NetworkService {
    
    private let config: NetworkConfigurableType
    private let sessionManager: NetworkSessionManagerType
    private let logger: NetworkErrorLoggerType
    
    public init(config: NetworkConfigurableType,
                sessionManager: NetworkSessionManagerType = NetworkSessionManager(),
                logger: NetworkErrorLoggerType = NetworkErrorLogger()) {
        self.config = config
        self.sessionManager = sessionManager
        self.logger = logger
    }
    
    private func request(request: URLRequest) -> URLTask {
        let task = Task {
            do {
                let (data, response) = try await sessionManager.request(request)
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                    throw NetworkError.error(statusCode: httpResponse.statusCode, data: data)
                  }
                logger.log(responseData: data, response: response)
                logger.log(request: request)
                return (data, response)
            } catch let requestError {
                let error = resolve(error: requestError)
                logger.log(error: error)
                throw error
            }
        }
        return task
    }
    
    private func resolve(error: Error) -> NetworkError {
        let code = URLError.Code(rawValue: (error as NSError).code)
        switch code {
        case .notConnectedToInternet: return .notConnected
        case .cancelled: return .cancelled
        default: return .generic(error)
        }
    }
}

extension NetworkService: NetworkServiceType {
    @discardableResult
    public func request(endpoint: RequestableType) throws -> URLTask {
        do {
            let urlRequest = try endpoint.urlRequest(with: config)
            return request(request: urlRequest)
        } catch {
            throw NetworkError.urlGeneration
        }
    }
}

public class NetworkSessionManager: NetworkSessionManagerType {
    public init() {}
    public func request(_ request: URLRequest) async throws -> DataResponse {
        let result = try await URLSession.shared.data(for: request)
        return result
    }
}

// MARK: - Logger

public final class NetworkErrorLogger: NetworkErrorLoggerType {
    public init() { }

    public func log(request: URLRequest) {
        print("-------------")
        print("request: \(request.url!)")
        print("headers: \(request.allHTTPHeaderFields!)")
        print("method: \(request.httpMethod!)")
        if let httpBody = request.httpBody, let result = ((try? JSONSerialization.jsonObject(with: httpBody, options: []) as? [String: AnyObject]) as [String: AnyObject]??) {
            printIfDebug("body: \(String(describing: result))")
        } else if let httpBody = request.httpBody, let resultString = String(data: httpBody, encoding: .utf8) {
            printIfDebug("body: \(String(describing: resultString))")
        }
    }

    public func log(responseData data: Data?, response: URLResponse?) {
        guard let data = data else { return }
        if let dataDict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
            printIfDebug("responseData: \(String(describing: dataDict))")
        }
    }

    public func log(error: Error) {
        printIfDebug("\(error)")
    }
}

extension Dictionary where Key == String {
    func prettyPrint() -> String {
        var string: String = ""
        if let data = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted) {
            if let nstr = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                string = nstr as String
            }
        }
        return string
    }
}

func printIfDebug(_ string: String) {
    #if DEBUG
    print(string)
    #endif
}
