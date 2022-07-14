//
//  WechatRequest.swift
//  SNSConnect
//
//  Created by 刘栋 on 2022/7/7.
//  Copyright © 2022 anotheren.com. All rights reserved.
//

import Foundation
import SNSConnect

public protocol WechatResponse: SNSResponse { }

extension WechatResponse {
    
    public var platform: SNSPlatform { .wechat }
}
