//
//  SNSSupport+Concurrency.swift
//  SNSConnect
//
//  Created by 刘栋 on 2022/7/11.
//  Copyright © 2022 anotheren.com. All rights reserved.
//

import Foundation

extension SNSAuthSupport {
    
    public func auth(_ request: SNSAuthRequest) async throws -> SNSResponse {
        return try await withCheckedThrowingContinuation { continuation in
            auth(request) { continuation.resume(with: $0) }
        }
    }
}

extension SNSShareSupport {
    
    public func share(_ request: SNSShareRequest) async throws -> SNSResponse {
        return try await withCheckedThrowingContinuation { continuation in
            share(request) { continuation.resume(with: $0) }
        }
    }
}

extension SNSAppClipsSupport {
    
    public func launch(_ request: SNSAppClipsRequest) async throws -> SNSResponse {
        return try await withCheckedThrowingContinuation { continuation in
            launch(request) { continuation.resume(with: $0) }
        }
    }
}

extension SNSPaySupport {
    
    public func pay(_ request: SNSPayRequest) async throws -> SNSResponse {
        return try await withCheckedThrowingContinuation { continuation in
            pay(request) { continuation.resume(with: $0) }
        }
    }
}
