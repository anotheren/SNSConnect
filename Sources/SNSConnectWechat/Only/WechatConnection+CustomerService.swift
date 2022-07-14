//
//  WechatConnection+CustomerService.swift
//  SNSConnect
//
//  Created by 刘栋 on 2022/7/7.
//  Copyright © 2022 anotheren.com. All rights reserved.
//

import Foundation
import SNSConnect
import SNSConnectWechatRebuild

extension SNSContextKey {
    
    static let customerService: SNSContextKey = "SNSConnect.ContextKey.Wechat.CustomerService"
}

extension SNSContext {
    
    var customerService: SNSResponseBlockContext? {
        get { values[.customerService] as? SNSResponseBlockContext }
        set { values[.customerService] = newValue }
    }
}

extension WechatConnection {
    
    func customService(_ request: WechatCustomerServiceRequest, completion: SNSResponseCompletion?) {
        coodinator.context.customerService = .init(completion: completion)
        let req = WXOpenCustomerServiceReq()
        req.corpid = request.corpID
        req.url = request.url
        WXApi.send(req)
    }
}

public struct WechatCustomerServiceRequest: WechatRequest {
    
    public let corpID: String
    public let url: String
    
    public init(corpID: String, url: String) {
        self.corpID = corpID
        self.url = url
    }
}

extension WechatRequest where Self == WechatCustomerServiceRequest {
    
    public static func customerService(corpID: String, url: String) -> WechatCustomerServiceRequest {
        WechatCustomerServiceRequest(corpID: corpID, url: url)
    }
}
