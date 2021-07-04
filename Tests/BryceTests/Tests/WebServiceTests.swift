//
//  File.swift
//  
//
//  Created by Ephraim Russo on 6/26/21.
//

import XCTest
import Bryce
import Combine
import Resolver

class WebServiceTests: XCTestCase {

    override func setUp() {
        Bryce.use(NetworkLoggingService(logLevel: .debug))
    }
    
    override func tearDown() {
        Bryce.teardown()
    }
    
    let webService = APIPostWebService()
    
    func testWebServiceGlobalConfig() {

        let urlString = "https://google.com"
        
        Bryce.config = .init(urlString)
        
        XCTAssertNotEqual(APIPostWebService().client.baseURL, URL(string: urlString))
    }
    
    func testWebServiceLocalConfig() {

        let urlString = "https://google.com"
        
        Bryce.config = .init(urlString)

        XCTAssertEqual(BasicPostWebService().client.baseURL, URL(string: urlString))
    }
    
    func testWebServiceRequest() throws {
            
        let posts = try awaitOutput(webService.getPostsPublisher())
        
        XCTAssertFalse(posts.isEmpty)        
    }
    
    func testWebServiceURIParam() throws {
        
        let postId: Post.ID = 1
        let commentId = 3

        XCTAssertEqual(webService.client.baseURL.appendingPathComponent("/posts/\(postId)"), URL(string: "https://jsonplaceholder.typicode.com/posts/\(postId)"))
        
        XCTAssertEqual(webService.client.baseURL.appendingPathComponent("/posts/\(postId)/comments/\(commentId)"), URL(string: "https://jsonplaceholder.typicode.com/posts/\(postId)/comments/\(commentId)"))
    }
}
