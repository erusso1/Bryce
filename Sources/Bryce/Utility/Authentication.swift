//
//  BRAuthorization.swift
//  Bryce
//
//  Created by Ephraim Russo on 2/6/19.
//

import Alamofire
import Foundation

public enum Authentication: Codable, Equatable {
    
    enum CodingKeys: CodingKey {
        case basic
        case bearer
    }
    
    case basic(username: String, password: String)
    
    case bearer(token: String, expiration: Date)
    
    public static let headerKey = "Authorization"
    
    public var headerValue: String {
        switch self {
        case .basic(let username, let password): return "Basic \((username + ":" + password).data(using: .utf8)!.base64EncodedString())"
        case .bearer(let token, _): return "Bearer \(token)"
        }
    }
    
    public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let key = container.allKeys[0]
        
        switch key {
        case .basic:
            let (username, password): (String, String) = try container.decodeValues(for: .basic)
            self = .basic(username: username, password: password)
        case .bearer:
            let (token, expiration): (String, Date) = try container.decodeValues(for: .bearer)
            self = .bearer(token: token, expiration: expiration)
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        switch self {
        case .basic(let username, let password):
            try container.encodeValues(username, password, for: .basic)
        case .bearer(let token, let expiration):
            try container.encodeValues(token, expiration, for: .bearer)
        }
    }
}

extension KeyedEncodingContainer {
    mutating func encodeValues<V1: Encodable, V2: Encodable>(
        _ v1: V1,
        _ v2: V2,
        for key: Key) throws {

        var container = self.nestedUnkeyedContainer(forKey: key)
        try container.encode(v1)
        try container.encode(v2)
    }
}

extension KeyedDecodingContainer {
    func decodeValues<V1: Decodable, V2: Decodable>(
        for key: Key) throws -> (V1, V2) {

        var container = try self.nestedUnkeyedContainer(forKey: key)
        return (
            try container.decode(V1.self),
            try container.decode(V2.self)
        )
    }
}
