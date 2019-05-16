//
//  ErrorLogger.swift
//  PDContactList
//
//  Created by David_Lam on 16/5/19.
//  Copyright © 2019 David_Lam. All rights reserved.
//

import Foundation

func logError(_ error: Error,
              file: String = #file,
              function: String = #function,
              line: Int = #line) {
    let errorDescription = "[\(file) - \(function): \(line)]"
    print(errorDescription)
}
