//
//  SNSSupport+Combine.swift
//  SNSConnect
//
//  Created by 刘栋 on 2022/7/11.
//  Copyright © 2022 anotheren.com. All rights reserved.
//

import Combine
import Foundation

extension SNSAuthSupport {
    
    public func auth(_ request: SNSAuthRequest) -> AnyPublisher<SNSResponse, SNSError> {
        return Future<SNSResponse, SNSError> { promise in
            auth(request) { promise($0) }
        }.eraseToAnyPublisher()
    }
}

extension SNSShareSupport {
    
    public func share(_ request: SNSShareRequest) -> AnyPublisher<SNSResponse, SNSError> {
        return Future<SNSResponse, SNSError> { promise in
            share(request) { promise($0) }
        }.eraseToAnyPublisher()
    }
}

extension SNSAppClipsConnection {
    
    public func launch(_ request: SNSAppClipsRequest) -> AnyPublisher<SNSResponse, SNSError> {
        return Future<SNSResponse, SNSError> { promise in
            launch(request) { promise($0) }
        }.eraseToAnyPublisher()
    }
}

extension SNSPaySupport {
    
    public func pay(_ request: SNSPayRequest) -> AnyPublisher<SNSResponse, SNSError> {
        return Future<SNSResponse, SNSError> { promise in
            pay(request) { promise($0) }
        }.eraseToAnyPublisher()
    }
}
