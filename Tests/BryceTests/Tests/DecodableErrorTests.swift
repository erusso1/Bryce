//
//  File.swift
//  
//
//  Created by Ephraim Russo on 6/30/21.
//

import XCTest
import Bryce
import Alamofire
import Resolver

struct CustomError: CodableError, Equatable {
    
    let reason: String
    let isFixable: Bool
}

extension Bryce {
    static func use(urlProtocol: AnyClass) {
        let config = URLSessionConfiguration.default
        config.protocolClasses = [urlProtocol]
        Bryce.config = .init(urlSessionConfiguration: config)
    }
}

class DecodableErrorTests: XCTestCase {
    
    override func setUp() {
        
        Bryce.use(urlProtocol: DecodableErrorProtocol.self)
    }
    
    override func tearDown() {
        Bryce.teardown()
    }
    
    let webService = APIPostWebService()

    func testDecodableErrorDecodes() {
        
        Bryce.use(DecodableErrorService(CustomError.self))
        
        let expectation = self.expectation(description: "Awaiting publisher")
        let customError = CustomError(reason: "Too bad", isFixable: false)
        
        DecodableErrorProtocol.error = customError

        let cancellable = webService
            .getPostsPublisher()
            .sink(receiveCompletion: { comp in
                
                switch comp {
                case .finished:
                    XCTFail("The request should fail")
                case .failure(let error):
                    XCTAssertTrue(error is CustomError)
                    XCTAssertEqual(error as! CustomError, customError)
                }
                
                expectation.fulfill()
                
            }, receiveValue: { _ in })
            
        waitForExpectations(timeout: 10)
        cancellable.cancel()
    }
    
    func testDefaultDecodableError() {
        
        let expectation = self.expectation(description: "Awaiting publisher")
        let customError = CustomError(reason: "So sad", isFixable: true)
        
        DecodableErrorProtocol.error = customError

        let cancellable = webService
            .getPostsPublisher()
            .sink(receiveCompletion: { comp in
                
                switch comp {
                case .finished:
                    XCTFail("The request should fail")
                case .failure(let error):
                    XCTAssertTrue(error is DecodingError)
                }
                
                expectation.fulfill()
                
            }, receiveValue: { _ in })
            
        waitForExpectations(timeout: 10)
        cancellable.cancel()
    }
}

final class DecodableErrorProtocol: URLProtocol {
    
    static var error: CustomError?
    
    override class func canInit(with request: URLRequest) -> Bool { true }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }
    
    override func startLoading() {
    
        guard
            let error = Self.error,
            let data = try? Bryce.config.requestEncoder.encode(error)
            else {
            stopLoading()
            return
        }
        
        let response = HTTPURLResponse(url: request.url!, statusCode: 403, httpVersion: nil, headerFields: nil)!
        client?.urlProtocol(self, didLoad: data)
        client?.urlProtocol(self, didReceive: response as URLResponse, cacheStoragePolicy: .notAllowed)
        client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() { }
}
