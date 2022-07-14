//
//  TencentConnection+Coodinator.swift
//  SNSConnect
//
//  Created by 刘栋 on 2022/6/14.
//  Copyright © 2022 anotheren.com. All rights reserved.
//

import Foundation
import SNSConnect
import SNSConnectTencentRebuild

extension TencentConnection {
    
    class Coodinator: NSObject {
        
        let context: SNSContext = .init()
    }
}

extension TencentConnection.Coodinator: QQApiInterfaceDelegate {
    
    func onReq(_ req: QQBaseReq!) {
        
    }
    
    func onResp(_ resp: QQBaseResp!) {
        switch resp {
        case let resp as SendMessageToQQResp:
            if let context = context.share {
                if resp.result == "0" {
                    context.completion?(.success(SNSCommonResponse(platform: .tencent)))
                } else {
                    context.completion?(.failure(.userCancel))
                }
            }
            context.share = nil
        default:
            debugPrint("Check \(String(describing: resp))")
        }
    }
    
    func isOnlineResponse(_ response: [AnyHashable: Any]!) {
        
    }
}

extension TencentConnection.Coodinator: TencentSessionDelegate {
    
    func tencentDidLogin() {
        if let authContext = context.auth, let util = authContext.userInfo[.tencentAuthUtil] as? TencentOAuth {
            if let authorizationCode = util.getServerSideCode(), !authorizationCode.isEmpty {
                authContext.completion?(.success(TencentAuthResponse(authorizationCode: authorizationCode)))
            } else {
                authContext.completion?(.failure(.authDeny))
            }
        }
        context.auth = nil
    }
    
    func tencentDidNotLogin(_ cancelled: Bool) {
        guard let auth = context.auth else { return }
        auth.completion?(.failure(.userCancel))
        context.auth = nil
    }
    
    func tencentDidNotNetWork() {
        
    }
}
