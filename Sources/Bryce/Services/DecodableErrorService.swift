//
//  File.swift
//  
//
//  Created by Ephraim Russo on 6/30/21.
//

import Foundation
import Resolver

public typealias CodableError = Error & Codable

protocol DecodableErrorProviding {
    
    func decode(_ data: Data, using decoder: JSONDecoder) throws -> Error
}

public struct DecodableErrorService<T: CodableError>: Service, DecodableErrorProviding {
    
    public var decodableType: T.Type { T.self }
    
    public func setup() { }
    
    public func teardown() { }
    
    func decode(_ data: Data, using decoder: JSONDecoder) throws -> Error {
        
        try decoder.decode(T.self, from: data)
    }
}

public extension DecodableErrorService where T: Codable {
    
    init(_ errorType: T.Type) { }
}

extension Bryce {
    
    static var decodableErrorService: DecodableErrorProviding? { Resolver.bryce.optional() }
}
