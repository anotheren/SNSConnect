//
//  WechatConnection.swift
//  SNSConnect
//
//  Created by 刘栋 on 2022/6/12.
//  Copyright © 2022 anotheren.com. All rights reserved.
//

import Foundation
import SNSConnect
import SNSConnectWechatRebuild

extension SNSPlatform {
    
    public static let wechat: SNSPlatform = "SNSConnect.Platform.Buildin.Wechat"
}

extension SNSConnect {
    
    public var wechat: WechatConnection {
        if let connection = connections[.wechat] as? WechatConnection {
            return connection
        } else {
            fatalError("You must resigter connection before use!")
        }
    }
}

public struct WechatConnection {
    
    internal let coodinator: Coodinator = .init()
    
    public let appID: String
    public let universalLink: String
    
    public init(appID: String, universalLink: String) {
        self.appID = appID
        self.universalLink = universalLink
    }
}

extension WechatConnection: SNSConnection {
    
    public var platform: SNSPlatform {
        .wechat
    }
    
    public var features: [SNSFeature] {
        [.auth, .share, .appClips, .pay]
    }
    
    public func isAppInstalled() -> Bool {
        WXApi.isWXAppInstalled()
    }
    
    @discardableResult
    public func openApp() -> Bool {
        WXApi.openWXApp()
    }
    
    public func register() {
        WXApi.registerApp(appID, universalLink: universalLink)
        #if DEBUG
        _checkLSApplicationQueriesSchemes("weixin", "weixinULAPI")
        #endif
    }
    
    public func unregister() {
        // Do not support
    }
    
    public func handleOpenURL(_ url: URL) -> Bool {
        WXApi.handleOpen(url, delegate: coodinator)
    }
    
    public func canHandleUniversalLink(_ url: URL) -> Bool {
        url.absoluteString.hasPrefix(universalLink)
    }
    
    public func handleUniversalLink(_ url: URL, userActivity: NSUserActivity) -> Bool {
        WXApi.handleOpenUniversalLink(userActivity, delegate: coodinator)
    }
}
