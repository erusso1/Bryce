////
////  Endpoint.swift
////  Bryce
////
////  Created by Ephraim Russo on 2/6/19.
////
//
//import Foundation
//import Alamofire
//
//public struct Endpoint {
//    
//    private let route: URL
//    
//    public init<T: LosslessStringConvertible>(components: [T]) {
//        
//        var url = Bryce.configuration.baseUrl
//        components.forEach { url = url.appendingPathComponent(String($0)) }
//        self.route = url
//    }
//    
//    public init<T: LosslessStringConvertible>(components: T...) {
//        self.init(components: components)
//    }
//    
//    public init(components: [RouteComponent]) {
//        let comps = components.map { $0.string }
//        self.init(components: comps)
//    }
//    
//    public init(components: RouteComponent...) {
//        self.init(components: components)
//    }
//}
//
//public struct RouteComponent {
//    
//    fileprivate let string : String
//    
//    private init(string: String) { self.string = string }
//}
//
//extension RouteComponent {
//    
//    public static func id(_ value: String) -> RouteComponent { return RouteComponent(value)! }
//}
//
//extension RouteComponent: LosslessStringConvertible {
//    
//    public init?(_ description: String) { self.init(string: description) }
//    
//    public var description: String { return string }
//}
//
//extension RouteComponent: ExpressibleByStringLiteral {
//    
//    public init(stringLiteral value: String) { self.init(string: value) }
//    
//    public init(unicodeScalarLiteral value: String) { self.init(string: value) }
//    
//    public init(extendedGraphemeClusterLiteral value: String) { self.init(string: value) }
//}
//
//extension Endpoint: URLConvertible {
//    
//    public func asURL() throws -> URL { return route }
//}
