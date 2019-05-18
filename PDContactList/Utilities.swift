//
//  Utilities.swift
//  PDContactList
//
//  Created by David_Lam on 12/5/19.
//  Copyright © 2019 David_Lam. All rights reserved.
//

import Foundation

//https://stackoverflow.com/a/32166735

import var CommonCrypto.CC_MD5_DIGEST_LENGTH
import func CommonCrypto.CC_MD5
import typealias CommonCrypto.CC_LONG

fileprivate func MD5(string: String) -> Data {
    let length = Int(CC_MD5_DIGEST_LENGTH)
    let messageData = string.data(using:.utf8)!
    var digestData = Data(count: length)
    
    _ = digestData.withUnsafeMutableBytes { digestBytes -> UInt8 in
        messageData.withUnsafeBytes { messageBytes -> UInt8 in
            if let messageBytesBaseAddress = messageBytes.baseAddress, let digestBytesBlindMemory = digestBytes.bindMemory(to: UInt8.self).baseAddress {
                let messageLength = CC_LONG(messageData.count)
                CC_MD5(messageBytesBaseAddress, messageLength, digestBytesBlindMemory)
            }
            return 0
        }
    }
    return digestData
}

extension String {
    func calculateMD5Hex() -> String {
        return getMD5Hex(string: self)
    }
}

func getMD5Hex(string: String) -> String {
    return MD5(string: string)
        .map { String(format: "%02hhx", $0) }
        .joined()
}
