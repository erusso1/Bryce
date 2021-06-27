//
//  File.swift
//  
//
//  Created by Ephraim Russo on 6/26/21.
//

import Foundation
import Alamofire

public protocol EndpointProviding {
    
    func url(baseURL: URL) -> URL
}

//@propertyWrapper
//public struct Endpoint: EndpointProviding {
//
//    public var wrappedValue: String
//
//    public init(wrappedValue: String) {
//        self.wrappedValue = wrappedValue
//    }
//
//    public var projectedValue: Self {
//        self
//    }
//
//    public func url(baseURL: URL) -> URL {
//        baseURL.appendingPathComponent(wrappedValue)
//    }
//}

@propertyWrapper
public struct Endpoint<T: URIParameterKey>: EndpointProviding {
    
    public var wrappedValue: String
    
    public init(wrappedValue: String) {
        self.wrappedValue = wrappedValue
    }
    
    init<T: URIParameterKey>(wrappedValue: String, _ uriParamKey: T.Type) {
        self.wrappedValue = wrappedValue
    }
    
    public var projectedValue: Self {
        self
    }
    
    public func url(baseURL: URL) -> URL {
        
        baseURL.appendingPathComponent(wrappedValue)
    }
    
    public func uri<V>(_ key: T, _ value: V) -> Endpoint<T> {
        
        guard let param = key.stringValue else { return self }
        let path = wrappedValue.replacingOccurrences(of: ":\(param)", with: "\(value)")
        return Endpoint<T>(wrappedValue: path)
    }
}

extension Endpoint where T == EmptyURIParamKey {
    public init(wrappedValue: String) {
        self.init(wrappedValue: wrappedValue, EmptyURIParamKey.self)
    }
}

public enum EmptyURIParamKey: URIParameterKey {

    public var stringValue: String? {  nil }
}

public protocol URIParameterKey: CaseIterable {
    
    var stringValue: String? { get }
}

public extension URIParameterKey where Self: RawRepresentable, RawValue == String {
    
    var stringValue: String? { rawValue }
}
