//
//  WechatShareContent.swift
//  SNSConnect
//
//  Created by 刘栋 on 2022/6/28.
//  Copyright © 2022 anotheren.com. All rights reserved.
//

import Foundation
import SNSConnect

public enum WechatShareContent {
    
    /// 纯文本
    case text(String)
    /// 图片
    case image(SNSImage)
    /// 链接
    case url(URL)
    /// 音乐
    case music(link: URL, data: URL)
    /// 视频
    case video(URL)
    /// 表情
    case emoticon(Data)
    /// 文件
    case file(data: Data, fileExtension: String)
    /// 小程序
    case appClips(WechatAppClipsInfo)
    
    public var matadata: SNSMatadata {
        switch self {
        case .text:
            return []
        case .image:
            return [.thumbnail]
        case .url:
            return [.title, .description, .thumbnail]
        case .music:
            return [.title, .description, .thumbnail]
        case .video:
            return [.title, .description, .thumbnail]
        case .emoticon:
            return [.thumbnail]
        case .file:
            return [.title, .description, .thumbnail]
        case .appClips:
            return [.title, .description, .thumbnail]
        }
    }
}
