//
//  TencentAppClips.swift
//  SNSConnect
//
//  Created by 刘栋 on 2022/6/28.
//  Copyright © 2022 anotheren.com. All rights reserved.
//

import Foundation
import SNSConnect
import SNSConnectTencentRebuild

public enum TencentAppClipsType: Int, Equatable {
    /// 开发版
    case develop = 0
    /// 测试版
    case test = 1
    /// 正式版
    case release = 3
    /// 预览版
    case preview = 4
}

extension TencentAppClipsType {
    
    var value: MiniProgramType {
        switch self {
        case .develop:
            return .develop
        case .test:
            return .test
        case .preview:
            return .preview
        case .release:
            return .online
        }
    }
}

public struct TencentAppClipsInfo {
   
    public let id: String
    public let path: String
    public let webpageUrl: String
    public let associatedContent: AssociatedContent
    public let type: TencentAppClipsType
    
    public init(id: String, path: String, webpageUrl: String, associatedContent: AssociatedContent, type: TencentAppClipsType = .release) {
        self.id = id
        self.path = path
        self.webpageUrl = webpageUrl
        self.associatedContent = associatedContent
        self.type = type
    }
}

extension TencentAppClipsInfo {
    
    public enum AssociatedContent {
        
        case url(URL)
        case audio(URL)
        case video(URL)
        
        var url: URL {
            switch self {
            case .url(let url), .audio(let url), .video(let url):
                return url
            }
        }
        
        var type: QQApiURLTargetType {
            switch self {
            case .url:
                return .news
            case .audio:
                return .audio
            case .video:
                return .video
            }
        }
    }
}
