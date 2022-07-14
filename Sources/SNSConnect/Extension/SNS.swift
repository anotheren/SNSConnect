//
//  SNS.swift
//  SNSConnect
//
//  Created by 刘栋 on 2022/6/30.
//  Copyright © 2022 anotheren.com. All rights reserved.
//

import Foundation

public struct SNSBase<Base> {
    
    public let base: Base
    
    public init(_ base: Base) {
        self.base = base
    }
}

public protocol SNSCompatible {
    
    static var sns: SNSBase<Self>.Type { get }
    var sns: SNSBase<Self> { get }
}

extension SNSCompatible {
    
    public static var sns: SNSBase<Self>.Type {
        SNSBase<Self>.self
    }
    
    public var sns: SNSBase<Self> {
        SNSBase(self)
    }
}
