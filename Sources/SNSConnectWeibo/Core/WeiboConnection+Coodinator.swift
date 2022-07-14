//
//  WeiboConnection+Coodinator.swift
//  SNSConnect
//
//  Created by 刘栋 on 2022/6/15.
//  Copyright © 2022 anotheren.com. All rights reserved.
//

import Foundation
import SNSConnect
import SNSConnectWeiboRebuild

extension WeiboConnection {
    
    class Coodinator: NSObject {
        
        let context: SNSContext = .init()
    }
}

extension WeiboConnection.Coodinator: WeiboSDKDelegate {
    
    func didReceiveWeiboRequest(_ request: WBBaseRequest?) {
        
    }
    
    func didReceiveWeiboResponse(_ response: WBBaseResponse?) {
        switch response {
        case let resp as WBAuthorizeResponse:
            if let authContext = context.auth {
                if resp.statusCode == .success, let response = WeiboAuthResponse(resp) {
                    authContext.completion?(.success(response))
                } else {
                    authContext.completion?(.failure(.userCancel))
                }
            }
            context.auth = nil
        case let resp as WBSendMessageToWeiboResponse:
            if let shareContext = context.share {
                if resp.statusCode == .success {
                    shareContext.completion?(.success(SNSCommonResponse(platform: .weibo)))
                } else {
                    shareContext.completion?(.failure(.userCancel))
                }
            }
            context.share = nil
        default:
            debugPrint("Check \(String(describing: response))")
        }
    }
}
