//
//  SNSResponse.swift
//  SNSConnect
//
//  Created by 刘栋 on 2022/7/6.
//  Copyright © 2022 anotheren.com. All rights reserved.
//

import Foundation

public protocol SNSResponse: SNSPlatformContent { }

public struct SNSCommonResponse: SNSResponse {
    
    public let platform: SNSPlatform
    
    public init(platform: SNSPlatform) {
        self.platform = platform
    }
}
