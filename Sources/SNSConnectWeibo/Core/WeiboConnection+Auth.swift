//
//  WeiboConnection.swift
//  SNSConnect
//
//  Created by 刘栋 on 2022/6/15.
//  Copyright © 2022 anotheren.com. All rights reserved.
//

import Foundation
import SNSConnect
import SNSConnectWeiboRebuild

extension SNSContextKey {
    
    static let auth: SNSContextKey = "SNSConnect.ContextKey.Weibo.Auth"
}

extension SNSContext {
    
    var auth: SNSResponseBlockContext? {
        get { values[.auth] as? SNSResponseBlockContext }
        set { values[.auth] = newValue }
    }
}

extension WeiboConnection: SNSAuthConnection {
    
    public func auth(_ request: SNSAuthRequest, completion: SNSResponseCompletion?) {
        guard isAppInstalled() else {
            completion?(.failure(.noAppInstalled(request.platform)))
            return
        }
        switch request {
        case let request as WeiboAuthRequest:
            coodinator.context.auth = .init(completion: completion)
            let req = WBAuthorizeRequest()
            req.scope = request.scpoe
            req.redirectURI = request.redirectURI
            WeiboSDK.send(req)
        default:
            completion?(.failure(.sdkInternalFailure)) // should never happen or check platform
        }
    }
}

public struct WeiboAuthRequest: SNSAuthRequest, WeiboRequest {
    
    public let scpoe: String
    public let redirectURI: String
}
 
extension SNSAuthRequest where Self == WeiboAuthRequest {
    
    public static func weibo(scpoe: String = "all",
                             redirectURI: String = "https://api.weibo.com/oauth2/default.html"
    ) -> WeiboAuthRequest {
        WeiboAuthRequest(scpoe: scpoe,
                         redirectURI: redirectURI)
    }
}

public struct WeiboAuthResponse: WeiboResponse {
    
    public let userID: String
    public let accessToken: String
    public let expirationDate: Date
    public let refreshToken: String?
}

extension WeiboAuthResponse {
    
    init?(_ resp: WBAuthorizeResponse) {
        guard let userID = resp.userID, let accessToken = resp.accessToken, let expirationDate = resp.expirationDate else {
            return nil
        }
        let refreshToken = resp.refreshToken
        self.init(userID: userID, accessToken: accessToken, expirationDate: expirationDate, refreshToken: refreshToken)
    }
}
