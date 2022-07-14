//
//  TencentResponse.swift
//  SNSConnect
//
//  Created by 刘栋 on 2022/7/12.
//  Copyright © 2022 anotheren.com. All rights reserved.
//

import Foundation
import SNSConnect

public protocol TencentResponse: SNSResponse { }

extension TencentResponse {
    
    public var platform: SNSPlatform { .tencent }
}
