//
//  SNSConnect+AppClips.swift
//  SNSConnect
//
//  Created by 刘栋 on 2022/7/1.
//  Copyright © 2022 anotheren.com. All rights reserved.
//

import Foundation

extension SNSConnect: SNSAppClipsSupport {
    
    public func launch(_ request: SNSAppClipsRequest, completion: SNSResponseCompletion? = nil) {
        guard let connection = connections[request.platform] else {
            completion?(.failure(.noConnectionRegistered(request.platform)))
            return
        }
        guard connection.features.contains(.appClips), let appClipsConnection = connection as? SNSAppClipsConnection else {
            completion?(.failure(.noFeatureSupported(.appClips)))
            return
        }
        appClipsConnection.launch(request, completion: completion)
    }
}

public protocol SNSAppClipsConnection: SNSConnection, SNSAppClipsSupport { }

public protocol SNSAppClipsSupport {
    
    func launch(_ request: SNSAppClipsRequest, completion: SNSResponseCompletion?)
}

public protocol SNSAppClipsRequest: SNSRequest { }
