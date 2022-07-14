//
//  SNSUserInfoKey.swift
//  SNSConnect
//
//  Created by 刘栋 on 2022/7/5.
//  Copyright © 2022 anotheren.com. All rights reserved.
//


import Foundation

public struct SNSUserInfoKey: RawRepresentable, Hashable {
    
    public let rawValue: String
    
    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}

extension SNSUserInfoKey: ExpressibleByStringLiteral {
    
    public init(stringLiteral value: StringLiteralType) {
        self.rawValue = value
    }
}
