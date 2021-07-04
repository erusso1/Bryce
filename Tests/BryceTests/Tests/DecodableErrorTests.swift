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

class DecodableErrorTests: XCTestCase {
    
    override func setUp() {
        
        Bryce.use(urlProtocol: DecodableErrorProtocol.self)
        
        DecodableErrorProtocol.customError = nil
        DecodableErrorProtocol.mismatchedError = nil
    }
    
    override func tearDown() {
        Bryce.teardown()
    }
    
    let webService = APIPostWebService()
    
    func testNoServiceRegistrationFails() {
        
        let customError = CustomError(reason: "So sad", isFixable: true)
        
        DecodableErrorProtocol.customError = customError

        XCTAssertThrowsError(try awaitOutput(webService.getPostsPublisher())) { error in
                    
            XCTAssertTrue(error is DecodingError)
        }
    }
    
    func testDecodableErrorDecodes() {
        
        Bryce.use(DecodableErrorService(CustomError.self))
        
        let customError = CustomError(reason: "Too bad", isFixable: false)
        
        DecodableErrorProtocol.customError = customError

        XCTAssertThrowsError(try awaitOutput(webService.getPostsPublisher())) { error in
                    
            guard let custom = error as? CustomError else { return XCTFail() }
            XCTAssertEqual(custom, customError)
        }
    }
    
    func testErrorTypeMismatchFails() {
        
        Bryce.use(DecodableErrorService(CustomError.self))
        
        DecodableErrorProtocol.mismatchedError = MismatchedError(message: "test message")
        
        XCTAssertThrowsError(try awaitOutput(webService.getPostsPublisher())) { error in
                    
            XCTAssertTrue(error is DecodingError)
        }
    }

}

struct MismatchedError: CodableError {
    let message: String
}
final class DecodableErrorProtocol: URLProtocol {
    
    static var customError: CustomError?
    
    static var mismatchedError: MismatchedError?
    
    override class func canInit(with request: URLRequest) -> Bool { true }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }
    
    override func startLoading() {
    
        if let customError = Self.customError,
           let data = try? Bryce.config.requestEncoder.encode(customError) {
            sendResponse(data)
        } else if let mistmatchedError = Self.mismatchedError,
                  let data = try? Bryce.config.requestEncoder.encode(mistmatchedError) {
            sendResponse(data)
        } else { stopLoading() }
    }
    
    private func sendResponse(_ data: Data) {
        
        let response = HTTPURLResponse(url: request.url!, statusCode: 403, httpVersion: nil, headerFields: nil)!
        client?.urlProtocol(self, didLoad: data)
        client?.urlProtocol(self, didReceive: response as URLResponse, cacheStoragePolicy: .notAllowed)
        client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() { }
}
