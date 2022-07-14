//
//  SNSPlatform.swift
//  SNSConnect
//
//  Created by 刘栋 on 2022/6/12.
//  Copyright © 2022 anotheren.com. All rights reserved.
//

import Foundation

public struct SNSPlatform: RawRepresentable, Hashable {
    
    public let rawValue: String
    
    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}

extension SNSPlatform: ExpressibleByStringLiteral {
    
    public init(stringLiteral value: String) {
        self.init(rawValue: value)
    }
}

extension SNSPlatform: CustomStringConvertible {
    
    public var description: String {
        rawValue
    }
}
