//
//  CannedResponseLoader.swift
//  TWNewsReaderTests
//
//  Created by David_Lam on 12/5/19.
//  Copyright © 2019 David_Lam. All rights reserved.
//

import Foundation

public class ResponseLoader {
    static func loadLocalResponse(file: String) -> Data {
        let bundle = Bundle(for: ResponseLoader.self)
        guard let url = bundle.url(forResource: file, withExtension: "json"),
            let data = try? Data(contentsOf: url) else {
                return Data()
        }
        return data
    }
}
