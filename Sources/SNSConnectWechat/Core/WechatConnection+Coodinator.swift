//
//  WechatConnection+Coodinator.swift
//  SNSConnect
//
//  Created by 刘栋 on 2022/6/12.
//  Copyright © 2022 anotheren.com. All rights reserved.
//

import Foundation
import SNSConnect
import SNSConnectWechatRebuild

extension WechatConnection {
    
    class Coodinator: NSObject {
        
        let context: SNSContext = .init()
    }
}

extension WechatConnection.Coodinator: WXApiDelegate {
    
    func onReq(_ req: BaseReq) {
        
    }
    
    func onResp(_ resp: BaseResp) {
        switch resp {
        case let resp as SendAuthResp:
            if let auth = context.auth {
                if resp.errCode == WXSuccess.rawValue, let response = WechatAuthResponse(resp) {
                    auth.completion?(.success(response))
                } else if resp.errCode == WXErrCodeAuthDeny.rawValue {
                    auth.completion?(.failure(.authDeny))
                } else {
                    auth.completion?(.failure(.userCancel))
                }
            }
            context.auth = nil
        case let resp as SendMessageToWXResp:
            if let share = context.share {
                if resp.errCode == WXSuccess.rawValue {
                    share.completion?(.success(SNSCommonResponse(platform: .wechat)))
                } else {
                    share.completion?(.failure(.userCancel))
                }
            }
            context.share = nil
        case let resp as WXLaunchMiniProgramResp:
            if let appClips = context.appClips {
                if resp.errCode == WXSuccess.rawValue {
                    appClips.completion?(.success(SNSCommonResponse(platform: .wechat)))
                } else {
                    appClips.completion?(.failure(.userCancel))
                }
            }
            context.appClips = nil
        case let resp as PayResp:
            if let pay = context.pay {
                if resp.errCode == WXSuccess.rawValue {
                    pay.completion?(.success(SNSCommonResponse(platform: .wechat)))
                } else if resp.errCode == WXErrCodeCommon.rawValue {
                    pay.completion?(.failure(.payFailure))
                } else {
                    pay.completion?(.failure(.userCancel))
                }
            }
            context.pay = nil
        case let resp as WXOpenCustomerServiceResp:
            if let customerService = context.customerService {
                if resp.errCode == WXSuccess.rawValue {
                    customerService.completion?(.success(SNSCommonResponse(platform: .wechat)))
                } else {
                    customerService.completion?(.failure(.userCancel))
                }
            }
            context.customerService = nil
        default:
            debugPrint("Check \(resp)")
        }
    }
}
