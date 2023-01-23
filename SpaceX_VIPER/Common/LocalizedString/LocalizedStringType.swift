//
//  LocalizedStringType.swift
//  SpaceX_VIPER
//
//  Created by wyn on 2023/1/23.
//

import Foundation

protocol LocalizedStringType { }

extension LocalizedStringType {
    var prefix: String { "\(type(of: self))" }
    var text: String { NSLocalizedString(prefix + "." + String(describing: self), comment: "") }
}

