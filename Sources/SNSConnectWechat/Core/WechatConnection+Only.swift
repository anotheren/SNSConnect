//
//  WechatConnection+Platform.swift
//  SNSConnect
//
//  Created by 刘栋 on 2022/7/11.
//  Copyright © 2022 anotheren.com. All rights reserved.
//

import Combine
import Foundation
import SNSConnect

extension WechatConnection {
    
    public func only(_ request: WechatRequest, completion: SNSResponseCompletion?) {
        switch request {
        case let request as WechatCustomerServiceRequest:
            customService(request, completion: completion)
        default:
            completion?(.failure(.sdkInternalFailure)) // should never happen
        }
    }
}

extension WechatConnection {
    
    public func only(_ request: WechatRequest) async throws -> SNSResponse {
        return try await withCheckedThrowingContinuation { continuation in
            only(request) { continuation.resume(with: $0) }
        }
    }
}
 
extension WechatConnection {
    
    public func only(_ request: WechatRequest) -> AnyPublisher<SNSResponse, SNSError> {
        return Future<SNSResponse, SNSError> { promise in
            only(request) { promise($0) }
        }.eraseToAnyPublisher()
    }
}
