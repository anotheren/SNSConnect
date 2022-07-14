//
//  WechatRequest.swift
//  SNSConnect
//
//  Created by 刘栋 on 2022/7/7.
//  Copyright © 2022 anotheren.com. All rights reserved.
//

import Foundation
import SNSConnect

public protocol WechatRequest: SNSRequest { }

extension WechatRequest {
    
    public var platform: SNSPlatform { .wechat }
}
