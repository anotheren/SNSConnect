//
//  TencentAuthPermission.swift
//  SNSConnect
//
//  Created by 刘栋 on 2022/7/12.
//  Copyright © 2022 anotheren.com. All rights reserved.
//

import Foundation
import SNSConnectTencentRebuild

public struct TencentAuthPermission: RawRepresentable, Hashable {
    
    public let rawValue: String
    
    public init(rawValue: String) {
        self.rawValue = rawValue
    }
    
    private init(_ rawValue: String) {
        self.init(rawValue: rawValue)
    }
}

extension TencentAuthPermission {
    
    /// 发表一条说说到QQ空间(需要申请权限)
    public static let addTopic: TencentAuthPermission = .init(kOPEN_PERMISSION_ADD_TOPIC)
    
    /// 创建一个QQ空间相册(需要申请权限)
    public static let addAlbum: TencentAuthPermission = .init(kOPEN_PERMISSION_ADD_ALBUM)
    
    /// 上传一张照片到QQ空间相册(需要申请权限)
    public static let uploadPic: TencentAuthPermission = .init(kOPEN_PERMISSION_UPLOAD_PIC)
    
    /// 获取用户QQ空间相册列表(需要申请权限)
    public static let listAlbum: TencentAuthPermission = .init(kOPEN_PERMISSION_LIST_ALBUM)
     
    /// 验证是否认证空间粉丝
    public static let checkPageFans: TencentAuthPermission = .init(kOPEN_PERMISSION_CHECK_PAGE_FANS)
    
    /// 获取登录用户自己的详细信息
    public static let info: TencentAuthPermission = .init(kOPEN_PERMISSION_GET_INFO)
    
    /// 获取其他用户的详细信息
    public static let otherInfo: TencentAuthPermission = .init(kOPEN_PERMISSION_GET_OTHER_INFO)
    
    /// 获取会员用户基本信息
    public static let vipInfo: TencentAuthPermission = .init(kOPEN_PERMISSION_GET_VIP_INFO)
    
    /// 获取会员用户详细信息
    public static let vipRichInfo: TencentAuthPermission = .init(kOPEN_PERMISSION_GET_VIP_RICH_INFO)
    
    /// 获取用户信息
    public static let userInfo: TencentAuthPermission = .init(kOPEN_PERMISSION_GET_USER_INFO)
    
    /// 移动端获取用户信息
    public static let simpleUserInfo: TencentAuthPermission = .init(kOPEN_PERMISSION_GET_SIMPLE_USER_INFO)
}
