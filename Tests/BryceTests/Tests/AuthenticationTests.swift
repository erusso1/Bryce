//
//  File.swift
//  
//
//  Created by Ephraim Russo on 7/1/21.
//

import XCTest
import Alamofire
import Bryce
import KeychainAccess

class AuthetenticationTests: XCTestCase {
    
    let webService = APIPostWebService()

    override func setUp() {

        Bryce.use(urlProtocol: AuthenticationURLProtocol.self)
    }
    
    override func tearDown() {
        Bryce.teardown()
    }
    
    func testAuthNotSetWithoutRegistration() {
        
        Bryce.setAuthentication(.basic(username: "username", password: "password"))
        XCTAssertNil(Bryce.authentication)
    }
    
    func testBasicAuthorization() {
                
        Bryce.use(AuthenticationService(persistence: .memory))
        Bryce.setAuthentication(.basic(username: "username", password: "password"))
        XCTAssertNotNil(Bryce.authentication)
    }
    
    func testBearerAuthorization() {
        
        Bryce.use(AuthenticationService(persistence: .memory))

        let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c"
        Bryce.setAuthentication(.bearer(token: token, expiration: Date(timeIntervalSinceNow: 3600)))
        XCTAssertNotNil(Bryce.authentication)
    }
    
    func testKeychainPersistence() throws {
        
        Bryce.use(AuthenticationService(persistence: .keychain))
        let testAuth = Authentication.basic(username: "username", password: "password")
        Bryce.setAuthentication(testAuth)

        XCTAssertNotNil(Bryce.authentication)
        XCTAssertEqual(Bryce.authentication, testAuth)
        
        let decoder = Bryce.config.responseDecoder
        guard let data = try Keychain().getData("Bryce.AuthenticationService.authentication") else { return }
        let auth = try decoder.decode(Authentication.self, from: data)
        
        XCTAssertEqual(auth, testAuth)
    }
    
    func testKeychainRemoval() throws {
     
        Bryce.use(AuthenticationService(persistence: .keychain))
        let testAuth = Authentication.basic(username: "username", password: "password")
        Bryce.setAuthentication(testAuth)

        XCTAssertNotNil(Bryce.authentication)
        XCTAssertEqual(Bryce.authentication, testAuth)
        
        Bryce.setAuthentication(nil)
        
        XCTAssertNil(Bryce.authentication)
        
        let data = try Keychain().getData("Bryce.AuthenticationService.authentication")
        
        XCTAssertNil(data)
    }
    
    func testAuthenticationInterceptor() throws {
        
        let expectation = self.expectation(description: "Awaiting publisher")
        let expectation2 = self.expectation(description: "Awaiting header validation")
        
        Bryce.use(AuthenticationService(persistence: .memory))
        let auth = Authentication.basic(username: "username", password: "password")
        Bryce.setAuthentication(auth)
        
        AuthenticationURLProtocol.auth = auth
        AuthenticationURLProtocol.headerValidation = { header in
            
            XCTAssertEqual(header, auth.headerValue)
            expectation2.fulfill()
        }
        
        let cancellable = webService
            .getPostsPublisher()
            .sink(receiveCompletion: { _ in
                    expectation.fulfill()
                
            }, receiveValue: { _ in })
            
        waitForExpectations(timeout: 10)
        cancellable.cancel()
    }
    
    func testTeardown() {
        Bryce.use(AuthenticationService(persistence: .memory))
        Bryce.setAuthentication(.basic(username: "username", password: "password"))
        Bryce.teardown()
        XCTAssertTrue(Bryce.interceptors.isEmpty)
        XCTAssertNil(Bryce.authentication)
    }
}

final class AuthenticationURLProtocol: URLProtocol {
    
    static var auth: Authentication?
    
    static var headerValidation: ((String) -> Void)?
    
    override class func canInit(with request: URLRequest) -> Bool { true }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }
    
    override func startLoading() {

        if let value = request.headers.value(for: "Authorization") {
            Self.headerValidation?(value)
        }
        
        let response = HTTPURLResponse(url: request.url!, statusCode: 403, httpVersion: nil, headerFields: nil)!
        client?.urlProtocol(self, didReceive: response as URLResponse, cacheStoragePolicy: .notAllowed)
        client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() { }
}
