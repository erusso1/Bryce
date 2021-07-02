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
}
