//
//  SNSConnect+Pay.swift
//  SNSConnect
//
//  Created by 刘栋 on 2022/6/28.
//  Copyright © 2022 anotheren.com. All rights reserved.
//

import Foundation

extension SNSConnect: SNSPaySupport {
    
    public func pay(_ request: SNSPayRequest, completion: SNSResponseCompletion? = nil) {
        guard let connection = connections[request.platform] else {
            completion?(.failure(.noConnectionRegistered(request.platform)))
            return
        }
        guard connection.features.contains(.pay), let payConnection = connection as? SNSPayConnection else {
            completion?(.failure(.noFeatureSupported(.pay)))
            return
        }
        payConnection.pay(request, completion: completion)
    }
}

public protocol SNSPayConnection: SNSConnection, SNSPaySupport { }

public protocol SNSPaySupport {
    
    func pay(_ request: SNSPayRequest, completion: SNSResponseCompletion?)
}

public protocol SNSPayRequest: SNSRequest { }
