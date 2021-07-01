//
//  ConfigurationTests.swift
//  
//
//  Created by Ephraim Russo on 6/26/21.
//

import XCTest
import Bryce

class ConfigurationTests: XCTestCase {
    
    override func setUp() {
        
        Bryce.use(AuthenticationService())
    }
    
    override func tearDown() {
        Bryce.teardown()
    }
    
    func testSetupConfiguration() {
        
        let timeout: TimeInterval = 3456
        let config = Configuration(timeout: timeout)
        
        Bryce.config = config

        XCTAssertEqual(config.timeout, Bryce.config.timeout)
    }
    
    func testGlobalURL() {
        
        let urlString = "https://jsonplaceholder.typicode.com"
        
        Bryce.config = .init(urlString)
        
        XCTAssertEqual(Bryce.config.globalBaseURL, URL(string: urlString))
    }
    
    func testBasicAuthorization() {
                
        Bryce.auth = .basic(username: "username", password: "password")
        XCTAssertEqual(Bryce.config.globalHeaders?["Authorization"], "Basic dXNlcm5hbWU6cGFzc3dvcmQ=")
    }
    
    func testBearerAuthorization() {
        let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c"
        Bryce.auth = .bearer(token: token, expiration: Date(timeIntervalSinceNow: 3600))
        XCTAssertEqual(Bryce.config.globalHeaders?["Authorization"], "Bearer \(token)")
    }
    
    func testTeardown() {
        Bryce.auth = .basic(username: "username", password: "password")
        Bryce.teardown()
        XCTAssertNil(Bryce.config.globalHeaders)
    }
}
