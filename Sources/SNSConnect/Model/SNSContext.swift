//
//  SNSContext.swift
//  SNSConnect
//
//  Created by 刘栋 on 2022/7/5.
//  Copyright © 2022 anotheren.com. All rights reserved.
//

import Foundation

public class SNSContext {
    
    public var values: [SNSContextKey: SNSContextCancelable]
    
    public init() {
        self.values = [:]
    }
}

extension SNSContext {
    
    public func cancelAll() {
        for (_, value) in values {
            value.cancel()
        }
        values.removeAll()
    }
}

public struct SNSContextKey: RawRepresentable, Hashable {
    
    public let rawValue: String
    
    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}

extension SNSContextKey: ExpressibleByStringLiteral {
    
    public init(stringLiteral value: StringLiteralType) {
        self.rawValue = value
    }
}

public protocol SNSContextCancelable {
    
    func cancel()
}

public typealias SNSResponseCompletion = (Result<SNSResponse, SNSError>) -> Void

public struct SNSResponseBlockContext {
    
    public let completion: SNSResponseCompletion?
    public let userInfo: [SNSUserInfoKey: Any]
    
    public init(completion: SNSResponseCompletion?, userInfo: [SNSUserInfoKey: Any] = [:]) {
        self.completion = completion
        self.userInfo = userInfo
    }
}

extension SNSResponseBlockContext: SNSContextCancelable {
    
    public func cancel() {
        completion?(.failure(.userCancel))
    }
}
