//
//  PostTranslatorTests.swift
//  TWNewsReaderTests
//
//  Created by David_Lam on 26/9/19.
//  Copyright © 2019 David_Lam. All rights reserved.
//

import XCTest
@testable import TWNewsReader

class PostTranslatorTests: XCTestCase {
    var response: Any!
    override func setUp() {
        response = ResponseLoader.loadLocalResponse(file: "StubPostsResponse")
    }

    func testPostTranslatorReturnsArrayOfPosts() {
        let translationResult = PostTranslator.translateFromNetworkResponse(data: response as! Data)
        guard case .success(let posts) = translationResult else {
            XCTFail("failed to parse from stub response")
            return
        }

        assert(posts.count == 100)

        let expectedFirstPost = Post(userId: 1,
                                     id: 1,
                                     title: "sunt aut facere repellat provident occaecati excepturi optio reprehenderit",
                                     body: "quia et suscipit\nsuscipit recusandae consequuntur expedita et cum\nreprehenderit molestiae ut ut quas totam\nnostrum rerum est autem sunt rem eveniet architecto")
        assert(posts.first == expectedFirstPost)

        let expectedLastPost = Post(userId: 10,
                                    id: 100,
                                    title: "at nam consequatur ea labore ea harum",
                                    body: "cupiditate quo est a modi nesciunt soluta\nipsa voluptas error itaque dicta in\nautem qui minus magnam et distinctio eum\naccusamus ratione error aut")
    }
}
