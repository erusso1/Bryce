//
//  File.swift
//  
//
//  Created by Ephraim Russo on 7/4/21.
//

import XCTest
import Bryce

class ResultWebServiceTests: XCTestCase {
    
    override func setUp() {
        
    }
    
    override func tearDown() {
        Bryce.teardown()
    }
    
    let webService: PostWebService = APIPostWebService()

    func testGetPostsSuccess() throws {
        
        let posts = try awaitResult { webService.getPosts(completion: $0) }
        
        XCTAssertFalse(posts.isEmpty)
    }
}
