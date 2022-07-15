//
//  SNSConnection.swift
//  SNSConnect
//
//  Created by 刘栋 on 2022/6/12.
//  Copyright © 2022 anotheren.com. All rights reserved.
//

import Foundation

public protocol SNSConnection: SNSPlatformContent {
    
    var features: [SNSFeature] { get }
    
    func register()
    func unregister()
    
    func isAppInstalled() -> Bool
    
    @discardableResult
    func openApp() -> Bool
    
    func handleOpenURL(_ url: URL) -> Bool
    func canHandleUniversalLink(_ url: URL) -> Bool
    func handleUniversalLink(_ url: URL, userActivity: NSUserActivity) -> Bool
}

#if DEBUG
extension SNSConnection {
    
    public func _checkLSApplicationQueriesSchemes(_ schemes: String...) {
        guard let infoDictionary = Bundle.main.infoDictionary, let applicationQueriesSchemes = infoDictionary["LSApplicationQueriesSchemes"] as? [String] else {
            return
        }
        for scheme in schemes where !applicationQueriesSchemes.contains(scheme) {
            assertionFailure("Please add \(scheme) in info.plist/LSApplicationQueriesSchemes")
        }
    }
}
#endif
