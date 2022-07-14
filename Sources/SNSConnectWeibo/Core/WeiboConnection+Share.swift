//
//  WeiboConnection+Share.swift
//  SNSConnect
//
//  Created by 刘栋 on 2022/6/28.
//  Copyright © 2022 anotheren.com. All rights reserved.
//

import Foundation
import SNSConnect
import SNSConnectWeiboRebuild

extension SNSContextKey {
    
    static let share: SNSContextKey = "SNSConnect.ContextKey.Weibo.Share"
}

extension SNSContext {
    
    var share: SNSResponseBlockContext? {
        get { values[.share] as? SNSResponseBlockContext }
        set { values[.share] = newValue }
    }
}

extension WeiboConnection: SNSShareSupport {
    
    public func share(_ request: SNSShareRequest, completion: SNSResponseCompletion? = nil) {
        guard isAppInstalled() else {
            completion?(.failure(.noAppInstalled(request.platform)))
            return
        }
        switch request {
        case let request as WeiboShareRequest:
            let result = request.makeRequest()
            switch result {
            case .success(let req):
                WeiboSDK.send(req)
            case .failure(let error):
                completion?(.failure(error))
            }
        default:
            completion?(.failure(.sdkInternalFailure)) // should never happen or check platform
        }
    }
}

public struct WeiboShareRequest: SNSShareRequest, WeiboRequest {
    
    public let title: String?
    public let description: String?
    public let thumbnail: SNSImage?
    public let content: WeiboShareContent
}

extension SNSShareRequest where Self == WeiboShareRequest {
    
    public static func weibo(title: String? = nil,
                             description: String? = nil,
                             thumbnail: SNSImage? = nil,
                             content: WeiboShareContent
    ) -> WeiboShareRequest {
        return WeiboShareRequest(title: title,
                                 description: description,
                                 thumbnail: thumbnail,
                                 content: content)
    }
}

extension WeiboShareRequest {
    
    fileprivate func makeRequest() -> Result<WBSendMessageToWeiboRequest, SNSError> {
        switch content {
        case .text(let text):
            let message = WBMessageObject()
            message.text = text
            let req = WBSendMessageToWeiboRequest()
            req.message = message
            return .success(req)
        case .image(let image):
            return image.loadData(limit: 10_000_000).map { imageData in
                let wbImage = WBImageObject()
                wbImage.imageData = imageData
                let message = WBMessageObject()
                message.imageObject = wbImage
                let req = WBSendMessageToWeiboRequest()
                req.message = message
                return req
            }
        }
    }
}
