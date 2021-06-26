//
//  Result+Bryce.swift
//  BryceNetworking
//
//  Created by Ephraim Russo on 9/3/19.
//

import Foundation

public extension Swift.Result {
    
    var value: Success? {
        
        switch self {
        case .success(let val): return val
        case .failure: return nil
        }
    }
    
    var error: Failure? {
        
        switch self {
        case .success: return nil
        case .failure(let error): return error
        }
    }
}
