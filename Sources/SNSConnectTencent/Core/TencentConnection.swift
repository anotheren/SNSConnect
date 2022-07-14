//
//  TencentConnection.swift
//  SNSConnect
//
//  Created by 刘栋 on 2022/6/12.
//  Copyright © 2022 anotheren.com. All rights reserved.
//

import Foundation
import SNSConnect
import SNSConnectTencentRebuild

extension SNSPlatform {
    
    public static let tencent: SNSPlatform = "SNSConnect.Platform.Buildin.Tencent"
}

extension SNSConnect {
    
    public var tencent: TencentConnection {
        if let connection = connections[.tencent] as? TencentConnection {
            return connection
        } else {
            fatalError("You must resigter connection before use!")
        }
    }
}

public struct TencentConnection {
    
    internal let coodinator: Coodinator = .init()
    
    public let appID: String
    public let universalLink: String
    
    public init(appID: String, universalLink: String) {
        self.appID = appID
        self.universalLink = universalLink
    }
}

extension TencentConnection: SNSConnection {
    
    public var platform: SNSPlatform {
        .tencent
    }
    
    public var features: [SNSFeature] {
        [.auth, .share]
    }
    
    public func register() {
        TencentOAuth.setIsUserAgreedAuthorization(true)
    }
    
    public func unregister() {
        // Do not support
    }
    
    public func isAppInstalled() -> Bool {
        QQApiInterface.isQQInstalled()
    }
    
    @discardableResult
    public func openApp() -> Bool {
        QQApiInterface.openQQ()
    }
    
    public func handleOpenURL(_ url: URL) -> Bool {
        if TencentOAuth.canHandleOpen(url) {
            return true
        } else if QQApiInterface.handleOpen(url, delegate: coodinator) {
            return true
        } else {
            return false
        }
    }
    
    public func handleUniversalLink(_ url: URL, userActivity: NSUserActivity) -> Bool {
        if TencentOAuth.handleUniversalLink(url) {
            return true
        } else if QQApiInterface.handleOpenUniversallink(url, delegate: coodinator) {
            return true
        } else {
            return false
        }
    }
}
