//
//  Misc.swift
//  Bryce
//
//  Created by Ephraim Russo on 1/28/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation

func testBearerAuthenticationRequest() {
    
    let baseURL = URL(string: "https://nebula-dev.metalpay.com")!
    let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySUQiOiIxOTYzNDUzNTAyMTY0MzA1MjczIiwic2Vzc2lvbklEIjoiMTEzNCIsImV4cCI6MTU0ODcyMzU2MiwiaWF0IjoxNTQ4NjYyNzY2fQ.8Fl_PxDePxcdDlr4GjipXymtiEJykQBptSlJqi2_awk"
    let expectation = XCTestExpectation(description: "Bearer authentication expectation.")
    
    final class PaginationResponse<T: Codable>: Codable {
        
        let contents: [T]
        let page: Int
        let pageSize: Int
        let totalElements: Int
    }
    
    final class Wallet: Codable {
        
        let id: String
        let user: String
        let createdAt: Date
    }
    
    Bryce.shared.configuration = .init(
        baseUrl: baseURL,
        securityPolicy: .none
    )
    
    Bryce.authorization = .bearer(token: token)
    
    firstly {
        
        try Bryce.request(baseURL.appendingPathComponent("v1.1").appendingPathComponent("wallets"), responseType: PaginationResponse<Wallet>.self)
        
        }.done { response in
            
            print("Successfully retreived \(response.contents.count) wallets.")
            XCTAssert(true)
            
        }.catch { error in
            
            print("An error occurred: \(error)")
            XCTAssert(false)
            
        }.finally {
            
            expectation.fulfill()
    }
    
    wait(for: [expectation], timeout: timeout)
}
