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
            
    public init(wrappedValue: String) {
        self.wrappedValue = wrappedValue
    }
    
    public var projectedValue: Self {
        self
    }
}
