//
//  Session.swift
//  TWNewsReader
//
//  Created by David_Lam on 27/9/19.
//  Copyright © 2019 David_Lam. All rights reserved.
//

import Foundation

protocol SessionType {
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: SessionType {}
