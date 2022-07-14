//
//  SNSConnect+Share.swift
//  SNSConnect
//
//  Created by 刘栋 on 2022/6/28.
//  Copyright © 2022 anotheren.com. All rights reserved.
//

import Foundation

extension SNSConnect: SNSShareSupport {
    
    public func share(_ request: SNSShareRequest, completion: SNSResponseCompletion? = nil) {
        guard let connection = connections[request.platform] else {
            completion?(.failure(.noConnectionRegistered(request.platform)))
            return
        }
        guard connection.features.contains(.share), let shareConnection = connection as? SNSShareConnection else {
            completion?(.failure(.noFeatureSupported(.share)))
            return
        }
        shareConnection.share(request, completion: completion)
    }
}

public protocol SNSShareConnection: SNSConnection, SNSShareSupport { }
 
public protocol SNSShareSupport {
    
    func share(_ request: SNSShareRequest, completion: SNSResponseCompletion?)
}

public protocol SNSShareRequest: SNSRequest {
    
    var title: String? { get }
    var description: String?  { get }
    var thumbnail: SNSImage?  { get }
}
