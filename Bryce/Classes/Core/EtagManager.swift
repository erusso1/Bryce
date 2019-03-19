//
//  EtagManager.swift
//  BryceNetworking
//
//  Created by Ephraim Russo on 3/14/19.
//

import Foundation
import Alamofire

struct EtagManager {
    
    private static let etagResponseHeaderKey = "Etag"

    private static let etagRequestHeaderKey = "If-None-Match"
    
    private static let etagMapDefaultsKey = "BryceNetworking.EtagMap"
    
    private static var _etagMap: [String : String]?
    
    private static var etagMap: [String : String]? {
        
        get {
            if let map = _etagMap { return map }
            else {
                let map = UserDefaults.standard.value(forKey: etagMapDefaultsKey) as? [String : String]
                _etagMap = map
                return map
            }
        }
        
        set {
            _etagMap = newValue
            UserDefaults.standard.set(newValue, forKey: etagMapDefaultsKey)
        }
    }
    
    private static func setEtag(_ etag: String, for urlString: String) {
        var map = etagMap ?? [:]
        map[urlString] = etag
        etagMap = map
    }
    
    private static func etag(for urlString: String) -> String? {
        
        return etagMap?[urlString]
    }
    
    static func headersFrom(endpoint: URLConvertible, method: HTTPMethod, etagEnabled: Bool, headers: HTTPHeaders?) -> HTTPHeaders? {
        
        guard method == .get && etagEnabled, let urlString = (try? endpoint.asURL())?.absoluteString else { return headers }
        
        var result = headers ?? [:]
        if let etag = etag(for: urlString) {
            result[etagRequestHeaderKey] = etag
        }
        
        return result
    }
    
    static func storeEtag(endpoint: URLConvertible, method: HTTPMethod, etagEnabled: Bool, response: DefaultDataResponse) {
        
        guard method == .get, etagEnabled == true, let etag = response.response?.allHeaderFields[etagResponseHeaderKey] as? String, let urlString = (try? endpoint.asURL())?.absoluteString else { return }
        
        setEtag(etag, for: urlString)
    }
    
    static func storeEtag(endpoint: URLConvertible, method: HTTPMethod, etagEnabled: Bool, response: DataResponse<Any>) {
        
        guard method == .get, etagEnabled == true, let etag = response.response?.allHeaderFields[etagResponseHeaderKey] as? String, let urlString = (try? endpoint.asURL())?.absoluteString else { return }

        setEtag(etag, for: urlString)
    }
    
    static func storeEtag<D: Decodable>(endpoint: URLConvertible, method: HTTPMethod, etagEnabled: Bool, response: DataResponse<D>) {
        
        guard method == .get, etagEnabled == true, let etag = response.response?.allHeaderFields[etagResponseHeaderKey] as? String, let urlString = (try? endpoint.asURL())?.absoluteString else { return }
        
        setEtag(etag, for: urlString)
    }
    
    static func clearEtagMap() {
        
        etagMap = nil
    }
}
