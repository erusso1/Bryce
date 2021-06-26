//
//  File.swift
//  
//
//  Created by Ephraim Russo on 6/26/21.
//

import Foundation
import Alamofire

@propertyWrapper
public struct Endpoint {
    
    public var wrappedValue: String
    
    let url: URL?
        
    public init(wrappedValue: String, _ url: URL? = nil) {
        self.wrappedValue = wrappedValue
        self.url = url
    }
    
    public var projectedValue: Self {
        self
    }
}
