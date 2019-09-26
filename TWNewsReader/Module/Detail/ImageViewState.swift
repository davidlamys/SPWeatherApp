//
//  DetailViewState.swift
//  TWNewsReader
//
//  Created by David_Lam on 17/5/19.
//  Copyright © 2019 David_Lam. All rights reserved.
//

import Foundation

enum ImageViewState {
    case localData(data: Data)
    case fetching
    case succeeded(data: Data)
    case failed
}

extension ImageViewState: Equatable {}
