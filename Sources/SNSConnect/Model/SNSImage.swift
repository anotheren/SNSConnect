//
//  SNSImage.swift
//  SNSConnect
//
//  Created by 刘栋 on 2022/6/28.
//  Copyright © 2022 anotheren.com. All rights reserved.
//

import UIKit
import Foundation

public enum SNSImage {

    case image(UIImage)
    case data(Data, autoCompress: Bool = true)
}

extension SNSImage {
    
    public func loadThumbnailData(limit: Int, maxPixel: CGFloat = 200) -> Result<Data, SNSError> {
        switch self {
        case .image(let image):
            if image.size.width <= maxPixel && image.size.height <= maxPixel {
                if let data = image.jpegData(compressionQuality: 1.0) {
                    if data.count > limit {
                        return SNSImage.image(image).loadData(limit: limit)
                    } else {
                        return .success(data)
                    }
                }
            } else {
                let newWidth: CGFloat
                let newHeight: CGFloat
                if image.size.width > image.size.height {
                    newWidth = maxPixel
                    newHeight = (newWidth / image.size.width) * image.size.height
                } else {
                    newHeight = maxPixel
                    newWidth = (newHeight / image.size.height) * image.size.width
                }
                
                let renderer = UIGraphicsImageRenderer(size: CGSize(width: newWidth, height: newHeight))
                let newImage = renderer.image { context in
                    image.draw(in: renderer.format.bounds)
                }
                if let data = newImage.jpegData(compressionQuality: 1.0) {
                    if data.count > limit {
                        return SNSImage.image(newImage).loadData(limit: limit)
                    } else {
                        return .success(data)
                    }
                }
            }
            return .failure(.imageCompression)
        case .data(let data, let autoCompress):
            if data.count > limit {
                if autoCompress {
                    guard let image = UIImage(data: data) else {
                        return .failure(.imageCompression)
                    }
                    return SNSImage.image(image).loadThumbnailData(limit: limit, maxPixel: maxPixel)
                } else {
                    return .failure(.outOfLimitSize)
                }
            } else {
                return .success(data)
            }
        }
    }
    
    public func loadData(limit: Int) -> Result<Data, SNSError> {
        switch self {
        case .image(let image):
            if let data = image.jpegData(compressionQuality: 1.0) {
                if data.count > limit {
                    var compressionQuality = 0.9
                    while compressionQuality >= 0.1 {
                        if let imageData = image.jpegData(compressionQuality: compressionQuality) {
                            if imageData.count > limit {
                                compressionQuality -= 0.1
                                continue
                            } else {
                                return .success(imageData)
                            }
                        }
                    }
                } else {
                    return .success(data)
                }
            }
        case .data(let data, let autoCompress):
            if data.count > limit {
                if autoCompress {
                    if let image = UIImage(data: data) {
                        return SNSImage.image(image).loadData(limit: limit)
                    }
                } else {
                    return .failure(.outOfLimitSize)
                }
            } else {
                return .success(data)
            }
        }
        return .failure(.imageCompression)
    }
}
