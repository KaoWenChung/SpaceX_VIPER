//
//  CancellableType.swift
//  SpaceX_VIPER
//
//  Created by wyn on 2023/1/17.
//

public protocol CancellableType {
    func cancel()
}

extension Task: CancellableType {}
