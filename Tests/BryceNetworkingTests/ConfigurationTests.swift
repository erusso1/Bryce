//
//  ConfigurationTests.swift
//  
//
//  Created by Ephraim Russo on 6/26/21.
//

import XCTest
import BryceNetworking

class ConfigurationTests: XCTestCase {
    
    func testSetupConfiguration() {
        
        let configuration = Configuration()
        
        Bryce.use(configuration)

        XCTAssertEqual(configuration.timeout, Bryce.configuration.timeout)
    }
    
    func testBasicAuthorization() {
        
        Bryce.use(.basic(username: "username", password: "password"))
        XCTAssertEqual(Bryce.configuration.globalHeaders?["Authorization"], "Basic dXNlcm5hbWU6cGFzc3dvcmQ=")
    }
    
    func testBearerAuthorization() {
        let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c"
        Bryce.use(.bearer(token: token))
        XCTAssertEqual(Bryce.configuration.globalHeaders?["Authorization"], "Bearer \(token)")
    }
    
    func testTeardown() {
        
        Bryce.use(.basic(username: "username", password: "password"))
        Bryce.teardown()
        XCTAssertNil(Bryce.configuration.globalHeaders)
    }
}
