//
//  WechatConnection+Auth.swift
//  SNSConnect
//
//  Created by 刘栋 on 2022/6/12.
//  Copyright © 2022 anotheren.com. All rights reserved.
//

import Foundation
import SNSConnect
import SNSConnectWechatRebuild

extension SNSContextKey {
    
    static let auth: SNSContextKey = "SNSConnect.ContextKey.Wechat.Auth"
}

extension SNSContext {
    
    var auth: SNSResponseBlockContext? {
        get { values[.auth] as? SNSResponseBlockContext }
        set { values[.auth] = newValue }
    }
}

extension WechatConnection: SNSAuthConnection {
    
    public func auth(_ request: SNSAuthRequest, completion: SNSResponseCompletion? = nil) {
        guard isAppInstalled() else {
            completion?(.failure(.noAppInstalled(request.platform)))
            return
        }
        switch request {
        case let request as WechatAuthRequest:
            coodinator.context.auth = .init(completion: completion)
            let req = SendAuthReq()
            req.scope = request.scope
            req.state = UUID().uuidString
            WXApi.sendAuthReq(req, viewController: .init(), delegate: coodinator, completion: nil)
        default:
            completion?(.failure(.sdkInternalFailure)) // should never happen or check platform
        }
    }
}

public struct WechatAuthRequest: SNSAuthRequest, WechatRequest {
    
    public let scope: String
}

extension SNSAuthRequest where Self == WechatAuthRequest {
    
    public static func wechat(scope: String = "snsapi_userinfo") -> WechatAuthRequest {
        WechatAuthRequest(scope: scope)
    }
}

public struct WechatAuthResponse: WechatResponse {
    
    public let authorizationCode: String
}

extension WechatAuthResponse {
    
    init?(_ resp: SendAuthResp) {
        guard let authorizationCode = resp.code, !authorizationCode.isEmpty else {
            return nil
        }
        self.init(authorizationCode: authorizationCode)
    }
}
