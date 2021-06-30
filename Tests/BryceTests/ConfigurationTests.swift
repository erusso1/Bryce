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
    
    func testSetupConfiguration() {
        
        let config = Configuration()
        
        Bryce.config = config

        XCTAssertEqual(config.timeout, Bryce.config.timeout)
    }
    
    func testGlobalURL() {
        
        let urlString = "https://jsonplaceholder.typicode.com"
        
        Bryce.use(urlString: urlString)
        
        XCTAssertEqual(Bryce.url, URL(string: urlString))
    }
    
    func testBasicAuthorization() {
                
        Bryce.authentication.authentication = .basic(username: "username", password: "password")
        XCTAssertEqual(Bryce.config.globalHeaders?["Authorization"], "Basic dXNlcm5hbWU6cGFzc3dvcmQ=")
    }
    
    func testBearerAuthorization() {
        let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c"
        Bryce.authentication.authentication = .bearer(token: token, expiration: Date(timeIntervalSinceNow: 3600))
        XCTAssertEqual(Bryce.config.globalHeaders?["Authorization"], "Bearer \(token)")
    }
    
    func testTeardown() {        
        Bryce.authentication.authentication = .basic(username: "username", password: "password")
        Bryce.teardown()
        XCTAssertNil(Bryce.config.globalHeaders)
    }
}
