//
//  SNSError.swift
//  SNSConnect
//
//  Created by 刘栋 on 2022/6/12.
//  Copyright © 2022 anotheren.com. All rights reserved.
//

import Foundation

public enum SNSError: Error {
    /// SDK内部错误
    case sdkInternalFailure
    /// 链接未注册
    case noConnectionRegistered(SNSPlatform)
    /// 不支持的平台功能
    case noFeatureSupported(SNSFeature)
    /// 应用未安装
    case noAppInstalled(SNSPlatform)
    /// 用户取消
    case userCancel
    /// 用户拒绝授权
    case authDeny
    /// 支付失败
    case payFailure
    /// 图片压缩失败
    case imageCompression
    /// 内容超出限制大小
    case outOfLimitSize
}
