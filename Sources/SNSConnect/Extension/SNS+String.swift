//
//  SNS+String.swift
//  SNSConnect
//
//  Created by 刘栋 on 2022/6/30.
//  Copyright © 2022 anotheren.com. All rights reserved.
//

import Foundation

extension String: SNSCompatible { }

extension SNSBase where Base == String {
    
    public func limit(_ maxLength: Int) -> String? {
        if base.utf16.count <= maxLength {
            return base
        } else if let fixed = String(base.utf16.prefix(maxLength)) {
            return fixed
        } else {
            return String(base.prefix(maxLength))
        }
    }
}
