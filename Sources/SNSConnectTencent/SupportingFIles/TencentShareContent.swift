//
//  TencentShareContent.swift
//  SNSConnect
//
//  Created by 刘栋 on 2022/7/12.
//  Copyright © 2022 anotheren.com. All rights reserved.
//

import Foundation
import SNSConnect

public enum TencentShareContent {
    /// 纯文本
    case text(String)
    /// 图片
    case image(SNSImage)
    /// 链接
    case url(URL)
    /// 音频
    case audio(URL)
    /// 视频
    case video(URL)
    /// 文件
    case file(Data, fileName: String)
    /// 小程序
    case appClips(TencentAppClipsInfo)
}
