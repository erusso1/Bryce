//
//  File.swift
//  
//
//  Created by Ephraim Russo on 6/26/21.
//

import XCTest
import Bryce
import Combine

class WebServiceTests: XCTestCase {
    
    private var cancellables = Set<AnyCancellable>()
    
    override func setUp() {
        Bryce.use(logLevel: .debug)
    }
    
    override func tearDown() {
        Bryce.teardown()
    }
    
    func testWebServiceGlobalConfig() {

        let urlString = "https://google.com"
        
        Bryce.use(urlString: urlString)
        
        XCTAssertNotEqual(APIPostWebService().client.baseURL, URL(string: urlString))
    }
    
    func testWebServiceLocalConfig() {

        let urlString = "https://google.com"
        
        Bryce.use(urlString: urlString)
        
        XCTAssertEqual(BasicPostWebService().client.baseURL, URL(string: urlString))
    }
    
    func testWebServiceRequest() throws {
    
        let webService = APIPostWebService()
        
        let posts = try awaitOutput(webService.getPostsPublisher())
        
        XCTAssertFalse(posts.isEmpty)        
    }
    
    func testWebServiceURIParam() throws {
        
        let webService = APIPostWebService()

        let postId: Post.ID = 1
        let commentId = 3

        XCTAssertEqual(webService.client.baseURL.appendingPathComponent("/posts/\(postId)"), URL(string: "https://jsonplaceholder.typicode.com/posts/\(postId)"))
        
        XCTAssertEqual(webService.client.baseURL.appendingPathComponent("/posts/\(postId)/comments/\(commentId)"), URL(string: "https://jsonplaceholder.typicode.com/posts/\(postId)/comments/\(commentId)"))
    }
}

extension XCTestCase {
    func awaitOutput<T: Publisher>(
        _ publisher: T,
        timeout: TimeInterval = 10,
        file: StaticString = #file,
        line: UInt = #line
    ) throws -> T.Output {
        // This time, we use Swift's Result type to keep track
        // of the result of our Combine pipeline:
        var result: Result<T.Output, Error>?
        let expectation = self.expectation(description: "Awaiting publisher")

        let cancellable = publisher.sink(
            receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    result = .failure(error)
                case .finished:
                    break
                }

                expectation.fulfill()
            },
            receiveValue: { value in
                result = .success(value)
            }
        )

        // Just like before, we await the expectation that we
        // created at the top of our test, and once done, we
        // also cancel our cancellable to avoid getting any
        // unused variable warnings:
        waitForExpectations(timeout: timeout)
        cancellable.cancel()

        // Here we pass the original file and line number that
        // our utility was called at, to tell XCTest to report
        // any encountered errors at that original call site:
        let unwrappedResult = try XCTUnwrap(
            result,
            "Awaited publisher did not produce any output",
            file: file,
            line: line
        )

        return try unwrappedResult.get()
    }
}
