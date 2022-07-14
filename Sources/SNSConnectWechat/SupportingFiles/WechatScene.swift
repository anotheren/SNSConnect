//
//  WechatScene.swift
//  SNSConnect
//
//  Created by 刘栋 on 2022/6/28.
//  Copyright © 2022 anotheren.com. All rights reserved.
//

import Foundation

public enum WechatScene: Int32, Equatable {
    /// 聊天界面
    case session = 0
    /// 朋友圈
    case timeline = 1
    /// 收藏
    case favourite = 2
}
