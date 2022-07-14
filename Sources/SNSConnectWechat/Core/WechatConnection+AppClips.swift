//
//  WechatConnection+AppClips.swift
//  SNSConnect
//
//  Created by 刘栋 on 2022/7/1.
//  Copyright © 2022 anotheren.com. All rights reserved.
//

import Foundation
import SNSConnect
import SNSConnectWechatRebuild

extension SNSContextKey {
    
    static let appClips: SNSContextKey = "SNSConnect.ContextKey.Wechat.AppClips"
}

extension SNSContext {
    
    var appClips: SNSResponseBlockContext? {
        get { values[.appClips] as? SNSResponseBlockContext }
        set { values[.appClips] = newValue }
    }
}

extension WechatConnection: SNSAppClipsConnection {
    
    public func launch(_ request: SNSAppClipsRequest, completion: SNSResponseCompletion? = nil) {
        guard isAppInstalled() else {
            completion?(.failure(.noAppInstalled(request.platform)))
            return
        }
        switch request {
        case let request as WechatAppClipsRequest:
            coodinator.context.appClips = .init(completion: completion)
            let req = WXLaunchMiniProgramReq()
            req.userName = request.userName
            req.path = request.path
            req.miniProgramType = request.type.value
            WXApi.send(req)
        default:
            completion?(.failure(.sdkInternalFailure)) // should never happen or check platform
        }
    }
}

public struct WechatAppClipsRequest: SNSAppClipsRequest, WechatRequest {
    
    public let userName: String
    public let path: String
    public let type: WechatAppClipsType
}

extension SNSAppClipsRequest where Self == WechatAppClipsRequest {
    
    public static func wechat(userName: String,
                              path: String,
                              type: WechatAppClipsType = .release
    ) -> WechatAppClipsRequest {
        WechatAppClipsRequest(userName: userName, path: path, type: type)
    }
}
