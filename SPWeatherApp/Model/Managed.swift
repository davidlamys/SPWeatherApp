//
//  Managed.swift
//  SPWeatherApp
//
//  Created by David_Lam on 27/9/19.
//  Copyright © 2019 David_Lam. All rights reserved.
//

import Foundation
import CoreData

protocol Managed {
    static var entityName: String { get }
    static var fetchRequest: NSFetchRequest<NSFetchRequestResult> { get }
}

extension Managed {
    static var fetchRequest: NSFetchRequest<NSFetchRequestResult> {
        return NSFetchRequest(entityName: entityName)
    }
}
