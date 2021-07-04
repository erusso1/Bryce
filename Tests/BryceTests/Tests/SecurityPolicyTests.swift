//
//  File.swift
//  
//
//  Created by Ephraim Russo on 7/3/21.
//

import XCTest
import Bryce
import Alamofire

class SecurityPolicyTests: XCTestCase {
 
    let webService = APIPostWebService()

    override func setUp() {
        
    }
    
    override func tearDown() {
        Bryce.teardown()
    }
    
    func testNoSercurityPolicySucceeds() throws {
        
        let posts = try awaitOutput(webService.getPostsPublisher())
        
        XCTAssertFalse(posts.isEmpty)
    }
    
    func testInvalidCertificatePinningFails() throws {
        
        Bryce.config = .init(securityPolicies: [
            .certifcatePinning(bundle: .module, host: "google.com")
        ])
        
        XCTAssertThrowsError(try awaitOutput(webService.getPostsPublisher())) { error in
            
            guard let afError = error as? AFError else { return XCTFail() }

            switch afError {
            case .serverTrustEvaluationFailed:
                XCTAssert(true)
            default:
                XCTFail()
            }
        }
    }
    
    func testInvalidPublicKeyPinningFails() throws {
        
        Bryce.config = .init(securityPolicies: [
            .publicKeyPinning(bundle: .module, host: "google.com")
        ])
        
        XCTAssertThrowsError(try awaitOutput(webService.getPostsPublisher())) { error in
            
            guard let afError = error as? AFError else { return XCTFail() }

            switch afError {
            case .serverTrustEvaluationFailed:
                XCTAssert(true)
            default:
                XCTFail()
            }
        }
    }
    
    func testValidCertificatePinningSucceeds() throws {
    
        Bryce.config = .init(securityPolicies: [
            .certifcatePinning(bundle: .module, host: "jsonplaceholder.typicode.com")
        ])
        
        XCTAssertNoThrow(try awaitOutput(webService.getPostsPublisher()))
    }
    
    func testValidPublicKeyPinningSucceeds() throws {
    
        Bryce.config = .init(securityPolicies: [
            .publicKeyPinning(bundle: .module, host: "jsonplaceholder.typicode.com")
        ])
        
        XCTAssertNoThrow(try awaitOutput(webService.getPostsPublisher()))
    }
}
