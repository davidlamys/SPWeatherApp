//
//  CannedResponseLoader.swift
//  PDContactListTests
//
//  Created by David_Lam on 12/5/19.
//  Copyright © 2019 David_Lam. All rights reserved.
//

import Foundation

public class ResponseLoader {
    static func loadLocalResponse(file: String) -> Data {
        guard let url = Bundle.init(identifier: "davidlam.PDContactListTests")!.url(forResource: file, withExtension: "json"),
            let data = try? Data(contentsOf: url) else {
                return Data()
        }
        return data
    }
}
