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
            .certifcatePinning(bundle: Self.bundle, host: "jsonplaceholder.typicode.com")
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
}
