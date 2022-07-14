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

extension SNSPlatform {
    
    public static let weibo: SNSPlatform = "SNSConnect.Platform.Buildin.Weibo"
}

extension SNSConnect {
    
    public var weibo: WeiboConnection {
        if let connection = connections[.weibo] as? WeiboConnection {
            return connection
        } else {
            fatalError("You must resigter connection before use!")
        }
    }
}

public struct WeiboConnection {
    
    internal let coodinator = Coodinator()
    
    public let appKey: String
    public let universalLink: String
    
    public init(appKey: String, universalLink: String) {
        self.appKey = appKey
        self.universalLink = universalLink
    }
}

extension WeiboConnection: SNSConnection {
    
    public var platform: SNSPlatform {
        .weibo
    }
    
    public var features: [SNSFeature] {
        [.auth, .share]
    }
    
    public func register() {
        WeiboSDK.registerApp(appKey, universalLink: universalLink)
        #if DEBUG
        _checkLSApplicationQueriesSchemes("weibosdk", "weibosdk2.5", "weibosdk3.3")
        #endif
    }
    
    public func unregister() {
        // Do not support
    }
    
    public func isAppInstalled() -> Bool {
        WeiboSDK.isWeiboAppInstalled()
    }
    
    @discardableResult
    public func openApp() -> Bool {
        WeiboSDK.openWeiboApp()
    }
    
    public func handleOpenURL(_ url: URL) -> Bool {
        WeiboSDK.handleOpen(url, delegate: coodinator)
    }
    
    public func handleUniversalLink(_ url: URL, userActivity: NSUserActivity) -> Bool {
        WeiboSDK.handleOpenUniversalLink(userActivity, delegate: coodinator)
    }
}
