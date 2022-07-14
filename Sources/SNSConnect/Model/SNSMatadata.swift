//
//  SNSMatadata.swift
//  SNSConnect
//
//  Created by 刘栋 on 2022/6/28.
//  Copyright © 2022 anotheren.com. All rights reserved.
//

import Foundation

public struct SNSMatadata: RawRepresentable, OptionSet {
    
    public let rawValue: UInt8
    
    public init(rawValue: UInt8) {
        self.rawValue = rawValue
    }
}

extension SNSMatadata {
    
    public static let title: SNSMatadata = .init(rawValue: 1 << 0)
    public static let description: SNSMatadata = .init(rawValue: 1 << 1)
    public static let thumbnail: SNSMatadata = .init(rawValue: 1 << 2)
}
