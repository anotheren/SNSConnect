//
//  WechatConnection+Pay.swift
//  SNSConnect
//
//  Created by 刘栋 on 2022/7/5.
//  Copyright © 2022 anotheren.com. All rights reserved.
//

import Foundation
import SNSConnect
import SNSConnectWechatRebuild

extension SNSContextKey {
    
    static let pay: SNSContextKey = "SNSConnect.ContextKey.Wechat.Pay"
}

extension SNSContext {
    
    var pay: SNSResponseBlockContext? {
        get { values[.pay] as? SNSResponseBlockContext }
        set { values[.pay] = newValue }
    }
}

extension WechatConnection: SNSPayConnection {
    
    public func pay(_ request: SNSPayRequest, completion: SNSResponseCompletion? = nil) {
        guard isAppInstalled() else {
            completion?(.failure(.noAppInstalled(request.platform)))
            return
        }
        switch request {
        case let request as WechatPayRequest:
            coodinator.context.pay = .init(completion: completion)
            let req = PayReq()
            req.partnerId = request.partnerId
            req.prepayId = request.prepayId
            req.nonceStr = request.nonceStr
            req.timeStamp = request.timeStamp
            req.package = request.package
            req.sign = request.sign
            WXApi.send(req)
        default:
            completion?(.failure(.sdkInternalFailure)) // should never happen or check platform
        }
    }
}

public struct WechatPayRequest: SNSPayRequest, WechatRequest {
    /// 商家向财付通申请的商家id
    public let partnerId: String
    /// 预支付订单
    public let prepayId: String
    /// 随机串，防重发
    public let nonceStr: String
    /// 时间戳，防重发
    public let timeStamp: UInt32
    /// 商家根据财付通文档填写的数据和签名
    public let package: String
    /// 商家根据微信开放平台文档对数据做的签名
    public let sign: String
}

extension SNSPayRequest where Self == WechatPayRequest {
    
    /// 微信支付
    /// - Parameters:
    ///   - partnerId: 商家向财付通申请的商家id
    ///   - prepayId: 预支付订单
    ///   - nonceStr: 随机串，防重发
    ///   - timeStamp: 时间戳，防重发
    ///   - package: 商家根据财付通文档填写的数据和签名
    ///   - sign: 商家根据微信开放平台文档对数据做的签名
    public static func wechat(partnerId: String,
                              prepayId: String,
                              nonceStr: String,
                              timeStamp: UInt32,
                              package: String,
                              sign: String
    ) -> WechatPayRequest {
        return WechatPayRequest(partnerId: partnerId,
                                prepayId: prepayId,
                                nonceStr: nonceStr,
                                timeStamp: timeStamp,
                                package: package,
                                sign: sign)
    }
}
