//
//  SNSConnect.swift
//  SNSConnect
//
//  Created by 刘栋 on 2022/6/12.
//  Copyright © 2022 anotheren.com. All rights reserved.
//

import Foundation

public let SNS = SNSConnect.shared

public struct SNSConnect {
    
    static let shared: SNSConnect = .init()
    
    private let storage: Storage = .init()
    
    private init() { }
}

extension SNSConnect {
    
    /// Registered connections
    public internal(set) var connections: [SNSPlatform: SNSConnection] {
        get { storage.connections }
        nonmutating set { storage.connections = newValue }
    }
}

extension SNSConnect {
    
    /// Add one or more `SNSConnection` instance, each platform only has one instance.
    /// According to the requirements of the privacy agreement, you must register
    ///  the relevant platform after the user agrees to your privacy agreement.
    ///
    /// - Wechat, also see `WechatConnection`
    /// - QQ, also see `TencentConnection`
    /// - Weibo, also see `WeiboConnection`
    public func register(_ connections: SNSConnection...) {
        connections.forEach {
            self.connections[$0.platform] = $0
            $0.register()
        }
    }
    
    /// Remove one or more `SNSConnection` instance for platform.
    /// - Soft removal, most platforms do not provide an unregister method.
    public func unregister(_ platforms: SNSPlatform...)  {
        platforms.forEach {
            if let connection = self.connections[$0] {
                connection.unregister()
            }
            self.connections[$0] = nil
        }
    }
}

extension SNSConnect {
    
    /// Check if a platform is registered.
    public func isRegister(_ platform: SNSPlatform) -> Bool {
        connections[platform] != nil
    }
    
    /// Check if a platform is installed.
    /// - Depends on the registered instance, please register first.
    public func isAppInstalled(_ platform: SNSPlatform) -> Bool {
        guard let connection = connections[platform] else {
            return false
        }
        return connection.isAppInstalled()
    }
}

extension SNSConnect {
    
    /// Handle `openURL` in `UIApplicationDelegate`
    public func handleOpenURL(_ url: URL) -> Bool {
        for (_, connection) in connections where connection.handleOpenURL(url) {
            return true
        }
        return false
    }
    
    /// Handle `continue userActivity` in `UIApplicationDelegate` or `UISceneDelegate`
    public func handleUserActivity(_ userActivity: NSUserActivity) -> Bool {
        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb, let url = userActivity.webpageURL else {
            return false
        }
        for (_, connection) in connections where connection.canHandleUniversalLink(url) {
            if connection.handleUniversalLink(url, userActivity: userActivity) {
                return true
            }
        }
        return false
    }
}

extension SNSConnect {
    
    private class Storage {
        
        var connections: [SNSPlatform: SNSConnection] = [:]
    }
}
