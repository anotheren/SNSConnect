//
//  WechatAppClips.swift
//  SNSConnect
//
//  Created by 刘栋 on 2022/6/28.
//  Copyright © 2022 anotheren.com. All rights reserved.
//

import Foundation
import SNSConnect
import SNSConnectWechatRebuild

public enum WechatAppClipsType: UInt8, Equatable {
    /// 正式版
    case release = 0
    /// 测试版
    case test = 1
    /// 体验版
    case preview = 2
}

extension WechatAppClipsType {
    
    var value: WXMiniProgramType {
        switch self {
        case .release:
            return .release
        case .test:
            return .test
        case .preview:
            return .preview
        }
    }
}

public struct WechatAppClipsInfo {
    
    public let url: URL
    public let userName: String
    public let path: String?
    public let previewImage: SNSImage?
    public let withShareTicket: Bool
    public let type: WechatAppClipsType
    public let userInfo: [String: Any]?
    
    public init(url: URL,
                userName: String,
                path: String? = nil,
                previewImage: SNSImage? = nil,
                withShareTicket: Bool = false,
                type: WechatAppClipsType = .release,
                userInfo: [String: Any]? = nil) {
        self.url = url
        self.userName = userName
        self.path = path
        self.previewImage = previewImage
        self.withShareTicket = withShareTicket
        self.type = type
        self.userInfo = userInfo
    }
}
