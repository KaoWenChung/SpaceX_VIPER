//
//  RepositoryTask.swift
//  SpaceX_VIPER
//
//  Created by wyn on 2023/1/17.
//

final class RepositoryTask: CancellableType {
    var networkTask: URLTask?
    var isCancelled: Bool = false
    
    func cancel() {
        networkTask?.cancel()
        isCancelled = true
    }
}
