//
//  WechatConnection+Share.swift
//  SNSConnect
//
//  Created by 刘栋 on 2022/6/28.
//  Copyright © 2022 anotheren.com. All rights reserved.
//

import Foundation
import SNSConnect
import SNSConnectWechatRebuild

extension SNSContextKey {
    
    static let share: SNSContextKey = "SNSConnect.ContextKey.Wechat.Share"
}

extension SNSContext {
    
    var share: SNSResponseBlockContext? {
        get { values[.share] as? SNSResponseBlockContext }
        set { values[.share] = newValue }
    }
}

extension WechatConnection: SNSShareConnection {
    
    public func share(_ request: SNSShareRequest, completion: SNSResponseCompletion? = nil) {
        guard isAppInstalled() else {
            completion?(.failure(.noAppInstalled(request.platform)))
            return
        }
        switch request {
        case let request as WechatShareRequest:
            let result = request.makeRequest()
            switch result {
            case .success(let req):
                coodinator.context.share = .init(completion: completion)
                WXApi.send(req)
            case .failure(let error):
                completion?(.failure(error))
            }
        default:
            completion?(.failure(.sdkInternalFailure)) // should never happen or check platform
        }
    }
}

public struct WechatShareRequest: SNSShareRequest, WechatRequest {
    
    public let scene: WechatScene
    public let title: String?
    public let description: String?
    public let thumbnail: SNSImage?
    public let content: WechatShareContent
}

extension SNSShareRequest where Self == WechatShareRequest {
    
    /// Share to WeChat
    /// - Parameters:
    ///   - scene: also see `WechatScene`
    ///   - title: optional, maxLength 512
    ///   - description: optional, maxLength 1024
    ///   - thumbnail: optional, limit size 64_000
    ///   - content: also see `WechatShareContent`
    public static func wechat(scene: WechatScene,
                              title: String? = nil,
                              description: String? = nil,
                              thumbnail: SNSImage? = nil,
                              content: WechatShareContent
    ) -> WechatShareRequest {
        WechatShareRequest(scene: scene,
                           title: title,
                           description: description,
                           thumbnail: thumbnail,
                           content: content)
    }
}

extension WechatShareRequest {
    
    fileprivate func makeRequest() -> Result<SendMessageToWXReq, SNSError> {
        switch content {
        case .text(let text):
            let req = SendMessageToWXReq()
            req.bText = true
            req.scene = scene.rawValue
            req.text = text
            return .success(req)
        case .image(let image):
            return image.loadData(limit: 25_000_000).map { imageData in
                let wxImage = WXImageObject()
                wxImage.imageData = imageData
                let wxMessage = makeWXMediaMessage(matadata: content.matadata)
                wxMessage.mediaObject = wxImage
                let req = SendMessageToWXReq()
                req.bText = false
                req.scene = scene.rawValue
                req.message = wxMessage
                return req
            }
        case .url(let url):
            let wxURL = WXWebpageObject()
            wxURL.webpageUrl = url.absoluteString
            let wxMessage = makeWXMediaMessage(matadata: content.matadata)
            wxMessage.mediaObject = wxURL
            let req = SendMessageToWXReq()
            req.bText = false
            req.scene = scene.rawValue
            req.message = wxMessage
            return .success(req)
        case .music(let linkURL, let dataURL):
            let wxMusic = WXMusicObject()
            wxMusic.musicUrl = linkURL.absoluteString
            wxMusic.musicDataUrl = dataURL.absoluteString
            let wxMessage = makeWXMediaMessage(matadata: content.matadata)
            wxMessage.mediaObject = wxMusic
            let req = SendMessageToWXReq()
            req.bText = false
            req.scene = scene.rawValue
            req.message = wxMessage
            return .success(req)
        case .video(let url):
            let wxVideo = WXVideoObject()
            wxVideo.videoUrl = url.absoluteString
            let wxMessage = makeWXMediaMessage(matadata: content.matadata)
            wxMessage.mediaObject = wxVideo
            let req = SendMessageToWXReq()
            req.bText = false
            req.scene = scene.rawValue
            req.message = wxMessage
            return .success(req)
        case .emoticon(let data):
            guard data.count <= 10_000_000 else {
                return .failure(.outOfLimitSize)
            }
            let wxEmoticon = WXEmoticonObject()
            wxEmoticon.emoticonData = data
            let wxMessage = makeWXMediaMessage(matadata: content.matadata)
            wxMessage.mediaObject = wxEmoticon
            let req = SendMessageToWXReq()
            req.bText = false
            req.scene = scene.rawValue
            req.message = wxMessage
            return .success(req)
        case .file(let data, let fileExtension):
            guard data.count <= 10_000_000 else {
                return .failure(.outOfLimitSize)
            }
            let wxFile = WXFileObject()
            wxFile.fileData = data
            wxFile.fileExtension = fileExtension
            let wxMessage = makeWXMediaMessage(matadata: content.matadata)
            wxMessage.mediaObject = wxFile
            let req = SendMessageToWXReq()
            req.bText = false
            req.scene = scene.rawValue
            req.message = wxMessage
            return .success(req)
        case .appClips(let info):
            let wxMiniProgram = WXMiniProgramObject()
            wxMiniProgram.webpageUrl = info.url.absoluteString
            wxMiniProgram.userName = info.userName
            wxMiniProgram.path = info.path
            wxMiniProgram.hdImageData = try? info.previewImage?.loadData(limit: 128_000).get()
            wxMiniProgram.withShareTicket = info.withShareTicket
            wxMiniProgram.miniProgramType = info.type.value
            wxMiniProgram.extraInfoDic = info.userInfo
            let wxMessage = makeWXMediaMessage(matadata: content.matadata)
            wxMessage.mediaObject = wxMiniProgram
            let req = SendMessageToWXReq()
            req.bText = false
            req.scene = scene.rawValue
            req.message = wxMessage
            return .success(req)
        }
    }
    
    private func makeWXMediaMessage(matadata: SNSMatadata) -> WXMediaMessage {
        let message = WXMediaMessage()
        if matadata.contains(.title), let fixedTitle = title?.sns.limit(512) {
            message.title = fixedTitle
        }
        if matadata.contains(.description), let fixedDescription = description?.sns.limit(1_024) {
            message.description = fixedDescription
        }
        if matadata.contains(.thumbnail), let thumbData = try? thumbnail?.loadThumbnailData(limit: 64_000).get() {
            message.thumbData = thumbData
        }
        return message
    }
}
