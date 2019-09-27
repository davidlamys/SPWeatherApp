//
//  PostObj.swift
//  TWNewsReader
//
//  Created by David_Lam on 27/9/19.
//  Copyright © 2019 David_Lam. All rights reserved.
//

import CoreData

@objc(PostObject)
final class PostObject: NSManagedObject {
    @NSManaged fileprivate(set) var userId: NSNumber
    @NSManaged fileprivate(set) var id: NSNumber
    @NSManaged fileprivate(set) var title: String
    @NSManaged fileprivate(set) var body: String

    static func insert(into context: NSManagedObjectContext, post: Post) -> PostObject {
        guard let postObj = NSEntityDescription.insertNewObject(forEntityName: "PostObject", into: context) as? PostObject else {
            fatalError("core data is not set up properly")
        }

        postObj.userId = NSNumber(value: post.userId)
        postObj.id = NSNumber(value: post.id)
        postObj.title = post.title
        postObj.body = post.body
        
        return postObj
    }
}

extension PostObject: Managed {
    static var entityName: String {
        return "PostObject"
    }
}
