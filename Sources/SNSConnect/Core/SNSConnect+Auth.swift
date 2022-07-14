//
//  SNSConnect+Auth.swift
//  SNSConnect
//
//  Created by 刘栋 on 2022/6/12.
//  Copyright © 2022 anotheren.com. All rights reserved.
//

import Foundation

extension SNSConnect: SNSAuthSupport {
    
    public func auth(_ request: SNSAuthRequest, completion: SNSResponseCompletion? = nil) {
        guard let connection = connections[request.platform] else {
            completion?(.failure(.noConnectionRegistered(request.platform)))
            return
        }
        guard connection.features.contains(.auth), let authConnection = connection as? SNSAuthConnection else {
            completion?(.failure(.noFeatureSupported(.auth)))
            return
        }
        authConnection.auth(request, completion: completion)
    }
}

public protocol SNSAuthConnection: SNSConnection, SNSAuthSupport { }

public protocol SNSAuthSupport {
    
    func auth(_ request: SNSAuthRequest, completion: SNSResponseCompletion?)
}

public protocol SNSAuthRequest: SNSRequest { }
