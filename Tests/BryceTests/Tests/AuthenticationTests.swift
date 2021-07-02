//
//  File.swift
//  
//
//  Created by Ephraim Russo on 7/1/21.
//

import XCTest
import Bryce
import KeychainAccess

class AuthetenticationTests: XCTestCase {
    
    override func setUp() {

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
        XCTAssertEqual(Bryce.config.globalHeaders["Authorization"], "Basic dXNlcm5hbWU6cGFzc3dvcmQ=")
        XCTAssertNotNil(Bryce.authentication)
    }
    
    func testBearerAuthorization() {
        
        Bryce.use(AuthenticationService(persistence: .memory))

        let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c"
        Bryce.setAuthentication(.bearer(token: token, expiration: Date(timeIntervalSinceNow: 3600)))
        XCTAssertEqual(Bryce.config.globalHeaders["Authorization"], "Bearer \(token)")
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
    
    func testTeardown() {
        Bryce.use(AuthenticationService(persistence: .memory))
        Bryce.setAuthentication(.basic(username: "username", password: "password"))
        Bryce.teardown()
        XCTAssertEqual(Bryce.config.globalHeaders.dictionary, Configuration.default.globalHeaders.dictionary)
        XCTAssertNil(Bryce.authentication)
    }
}

