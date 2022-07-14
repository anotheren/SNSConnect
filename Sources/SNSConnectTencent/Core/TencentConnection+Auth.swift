//
//  TencentConnection+Auth.swift
//  SNSConnect
//
//  Created by 刘栋 on 2022/6/12.
//  Copyright © 2022 anotheren.com. All rights reserved.
//

import Foundation
import SNSConnect
import SNSConnectTencentRebuild

extension SNSContextKey {
    
    static let auth: SNSContextKey = "SNSConnect.ContextKey.Tencent.Auth"
}

extension SNSContext {
    
    var auth: SNSResponseBlockContext? {
        get { values[.auth] as? SNSResponseBlockContext }
        set { values[.auth] = newValue }
    }
}

extension SNSUserInfoKey {
    
    static let tencentAuthUtil: SNSUserInfoKey = "SNSConnect.UserInfoKey.Tencent.AuthUtil"
}

extension TencentConnection: SNSAuthConnection {
    
    public func auth(_ request: SNSAuthRequest, completion: SNSResponseCompletion?) {
        guard isAppInstalled() else {
            completion?(.failure(.noAppInstalled(request.platform)))
            return
        }
        switch request {
        case let request as TencentAuthRequest:
            guard let util = TencentOAuth(appId: appID, enableUniveralLink: true, universalLink: universalLink, delegate: coodinator) else {
                completion?(.failure(.authDeny))
                return
            }
            coodinator.context.auth = .init(completion: completion, userInfo: [.tencentAuthUtil: util])
            util.authShareType = AuthShareType_QQ
            util.authMode = TencentAuthMode.authModeServerSideCode
            let persmissions = request.permissions.map { $0.rawValue }
            util.authorize(persmissions)
        default:
            completion?(.failure(.sdkInternalFailure)) // should never happen or check platform
        }
    }
}

public struct TencentAuthRequest: SNSAuthRequest, TencentRequest {
    
    public let permissions: [TencentAuthPermission]
}

extension SNSAuthRequest where Self == TencentAuthRequest {
    
    public static func tencent(permissions: [TencentAuthPermission] = [.simpleUserInfo, .info, .userInfo]
    ) -> TencentAuthRequest {
        TencentAuthRequest(permissions: permissions)
    }
}

public struct TencentAuthResponse: TencentResponse {
    
    public let authorizationCode: String
}
