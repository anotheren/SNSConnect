//
//  TencentConnection+Share.swift
//  SNSConnect
//
//  Created by 刘栋 on 2022/6/28.
//  Copyright © 2022 anotheren.com. All rights reserved.
//

import Foundation
import SNSConnect
import SNSConnectTencentRebuild

extension SNSContextKey {
    
    static let share: SNSContextKey = "SNSConnect.ContextKey.Tencent.Share"
}

extension SNSContext {
    
    var share: SNSResponseBlockContext? {
        get { values[.share] as? SNSResponseBlockContext }
        set { values[.share] = newValue }
    }
}

extension TencentConnection: SNSShareSupport {
    
    public func share(_ request: SNSShareRequest, completion: SNSResponseCompletion? = nil) {
        guard isAppInstalled() else {
            completion?(.failure(.noAppInstalled(request.platform)))
            return
        }
        switch request {
        case let request as TencentShareRequest:
            let result = request.makeRequest(universalLink: universalLink)
            switch result {
            case .success(let req):
                coodinator.context.share = .init(completion: completion)
                switch request.secne {
                case .session:
                    QQApiInterface.send(req)
                case .qzone:
                    QQApiInterface.sendReq(toQZone: req)
                }
            case .failure(let error):
                completion?(.failure(error))
            }
        default:
            completion?(.failure(.sdkInternalFailure)) // should never happen or check platform
        }
    }
}

public struct TencentShareRequest: SNSShareRequest, TencentRequest {
    
    public let secne: TencentScene
    public let title: String?
    public let description: String?
    public let thumbnail: SNSImage?
    public let content: TencentShareContent
}

extension SNSShareRequest where Self == TencentShareRequest {
    
    public static func tencent(secne: TencentScene,
                               title: String? = nil,
                               description: String? = nil,
                               thumbnail: SNSImage? = nil,
                               content: TencentShareContent
    ) -> TencentShareRequest {
        TencentShareRequest(secne: secne,
                            title: title,
                            description: description,
                            thumbnail: thumbnail,
                            content: content)
    }
}

extension TencentShareRequest {
    
    fileprivate func makeRequest(universalLink: String) -> Result<SendMessageToQQReq, SNSError> {
        switch content {
        case .text(let text):
            if let qqText = QQApiTextObject(text: text) {
                qqText.universalLink = universalLink
                if let req = SendMessageToQQReq(content: qqText) {
                    return .success(req)
                }
            }
        case .image(let image):
            let result = image.loadData(limit: 5_000_000)
            switch result {
            case .success(let imageData):
                if let qqImage = QQApiImageObject(data: imageData,
                                                  previewImageData: try? thumbnail?.loadThumbnailData(limit: 1_000_000).get(),
                                                  title: title,
                                                  description: description) {
                    qqImage.universalLink = universalLink
                    if let req = SendMessageToQQReq(content: qqImage) {
                        return .success(req)
                    }
                }
            case .failure(let error):
                return .failure(error)
            }
        case .url(let url):
            if let qqURL = QQApiURLObject(url: url,
                                          title: title,
                                          description: description,
                                          previewImageData: try? thumbnail?.loadThumbnailData(limit: 1_000_000).get(),
                                          targetContentType: .news) {
                qqURL.universalLink = universalLink
                if let req = SendMessageToQQReq(content: qqURL) {
                    return .success(req)
                }
            }
        case .audio(let url):
            if let qqAudio = QQApiAudioObject(url: url,
                                              title: title,
                                              description: description,
                                              previewImageData: try? thumbnail?.loadThumbnailData(limit: 1_000_000).get(),
                                              targetContentType: .audio) {
                qqAudio.universalLink = universalLink
                if let req = SendMessageToQQReq(content: qqAudio) {
                    return .success(req)
                }
            }
        case .video(let url):
            if let qqVideo = QQApiVideoObject(url: url,
                                              title: title,
                                              description: description,
                                              previewImageData: try? thumbnail?.loadThumbnailData(limit: 1_000_000).get(),
                                              targetContentType: .video) {
                qqVideo.universalLink = universalLink
                if let req = SendMessageToQQReq(content: qqVideo) {
                    return .success(req)
                }
            }
        case .file(let fileData, let fileName):
            if let qqFile = QQApiFileObject(data: fileData,
                                            previewImageData: try? thumbnail?.loadThumbnailData(limit: 1_000_000).get(),
                                            title: title,
                                            description: description) {
                qqFile.fileName = fileName
                qqFile.universalLink = universalLink
                if let req = SendMessageToQQReq(content: qqFile) {
                    return .success(req)
                }
            }
        case .appClips(let appClips):
            // also see: https://wiki.connect.qq.com/分享小程序消息到qq和空间-（3-3-5）（qq-8-0-8）
            if let qqVideo = QQApiVideoObject(url: appClips.associatedContent.url,
                                              title: title,
                                              description: description,
                                              previewImageData: try? thumbnail?.loadThumbnailData(limit: 1_000_000).get(),
                                              targetContentType: appClips.associatedContent.type) {
                qqVideo.universalLink = universalLink
                switch secne {
                case .session:
                    let p1 = kQQAPICtrlFlag.qqapiCtrlFlagQQShareEnableMiniProgram.rawValue
                    qqVideo.cflag = UInt64(p1)
                case .qzone:
                    let p1 = kQQAPICtrlFlag.qqapiCtrlFlagQQShareEnableMiniProgram.rawValue
                    let p2 = kQQAPICtrlFlag.qqapiCtrlFlagQZoneShareOnStart.rawValue
                    qqVideo.cflag = UInt64(p1 | p2)
                }
                let qqAppClips = QQApiMiniProgramObject()
                qqAppClips.qqApiObject = qqVideo
                qqAppClips.miniAppID = appClips.id
                qqAppClips.miniPath = appClips.path
                qqAppClips.webpageUrl = appClips.webpageUrl
                qqAppClips.miniprogramType = appClips.type.value
                if let req = SendMessageToQQReq(miniContent: qqAppClips) {
                    return .success(req)
                }
            }
        }
        return .failure(.sdkInternalFailure)
    }
}
