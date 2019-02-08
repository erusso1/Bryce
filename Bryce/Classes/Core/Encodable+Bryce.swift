//
//  Encodable+Bryce.swift
//  BryceNetworking
//
//  Created by Ephraim Russo on 2/7/19.
//

import Alamofire
import Foundation

extension Encodable {
    
    internal func parameters(using encoder: JSONEncoder) throws -> Parameters {
        
        let data = try encoder.encode(self)
        
        guard let params = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] else { throw EncodingError.invalidValue(parameters, .init(codingPath: [], debugDescription: "Unable to encode parameters: \(parameters)")) }
        
        return params
    }
}
