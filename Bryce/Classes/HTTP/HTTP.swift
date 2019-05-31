//
//  Request.swift
//  Bryce
//
//  Created by Ephraim Russo on 1/22/19.
//

import Foundation
import Alamofire
import CodableAlamofire

public typealias DefaultAlamofireResponse = (DefaultDataResponse) -> Void

public typealias JSONAlamofireResponse = (DataResponse<Any>) -> Void

public typealias ErrorResponse = (Error?) -> Void

public typealias JSONResponse = (JSON?, Error?) -> Void

public typealias JSONArrayResponse = (Array<JSON>?, Error?) -> Void

public typealias DecodableResponse<D: Decodable> = (D?, Error?) -> Void

extension Bryce {
    
    @discardableResult
    public func request(on endpoint: URLConvertible, method: HTTPMethod = .get, parameters: Parameters? = nil, encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders? = nil, validate: Bool = true, etagEnabled: Bool = false, response: @escaping DefaultAlamofireResponse) -> DataRequest {
        
        let headersToSend = EtagManager.headersFrom(endpoint: endpoint, method: method, etagEnabled: etagEnabled, headers: headers)
        
        var dataRequest: DataRequest
        
        if etagEnabled && method == .get { dataRequest = self.configuration.sessionManager.requestWithoutCache(endpoint, method: method, parameters: parameters, encoding: encoding, headers: headersToSend) }
            
        else { dataRequest = self.configuration.sessionManager.request(endpoint, method: method, parameters: parameters, encoding: encoding, headers: headersToSend) }
        
        if validate { dataRequest = dataRequest.validate(statusCode: configuration.acceptableStatusCodes) }
        
        dataRequest.response(queue: self.configuration.responseQueue) { alamofireResponse in
            
            EtagManager.storeEtag(endpoint: endpoint, method: method, etagEnabled: etagEnabled, response: alamofireResponse)
            
            response(alamofireResponse)
        }
        
        return dataRequest
    }
    
    @discardableResult
    public func request(on endpoint: URLConvertible, method: HTTPMethod = .get, parameters: Parameters? = nil, encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders? = nil, validate: Bool = true, etagEnabled: Bool = false, response: @escaping ErrorResponse) -> DataRequest {
        
        let headersToSend = EtagManager.headersFrom(endpoint: endpoint, method: method, etagEnabled: etagEnabled, headers: headers)

        var dataRequest: DataRequest
        
        if etagEnabled && method == .get { dataRequest = self.configuration.sessionManager.requestWithoutCache(endpoint, method: method, parameters: parameters, encoding: encoding, headers: headersToSend) }
            
        else { dataRequest = self.configuration.sessionManager.request(endpoint, method: method, parameters: parameters, encoding: encoding, headers: headersToSend) }
        
        if validate { dataRequest = dataRequest.validate(statusCode: configuration.acceptableStatusCodes) }
            
        dataRequest.response(queue: self.configuration.responseQueue) { alamofireResponse in
            
            let error = alamofireResponse.error
            
            EtagManager.storeEtag(endpoint: endpoint, method: method, etagEnabled: etagEnabled, response: alamofireResponse)
            
            response(error)
        }
        
        return dataRequest
    }
    
    @discardableResult
    public func request(on endpoint: URLConvertible, method: HTTPMethod = .get, parameters: Parameters? = nil, encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders? = nil, validate: Bool = true, etagEnabled: Bool = false, response: @escaping JSONAlamofireResponse) -> DataRequest {
        
        let headersToSend = EtagManager.headersFrom(endpoint: endpoint, method: method, etagEnabled: etagEnabled, headers: headers)

        var dataRequest: DataRequest
        
        if etagEnabled && method == .get { dataRequest = self.configuration.sessionManager.requestWithoutCache(endpoint, method: method, parameters: parameters, encoding: encoding, headers: headersToSend) }
            
        else { dataRequest = self.configuration.sessionManager.request(endpoint, method: method, parameters: parameters, encoding: encoding, headers: headersToSend) }
        
        if validate { dataRequest = dataRequest.validate(statusCode: configuration.acceptableStatusCodes) }
        
        dataRequest.responseJSON(queue: self.configuration.responseQueue) { alamofireResponse in
            
            EtagManager.storeEtag(endpoint: endpoint, method: method, etagEnabled: etagEnabled, response: alamofireResponse)
            
            response(alamofireResponse)
        }
        
        return dataRequest
    }
    
    @discardableResult
    public func request(on endpoint: URLConvertible, method: HTTPMethod = .get, parameters: Parameters? = nil, encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders? = nil, validate: Bool = true, etagEnabled: Bool = false, response: @escaping JSONResponse) -> DataRequest {
        
        let headersToSend = EtagManager.headersFrom(endpoint: endpoint, method: method, etagEnabled: etagEnabled, headers: headers)
        
        var dataRequest: DataRequest
        
        if etagEnabled && method == .get { dataRequest = self.configuration.sessionManager.requestWithoutCache(endpoint, method: method, parameters: parameters, encoding: encoding, headers: headersToSend) }
            
        else { dataRequest = self.configuration.sessionManager.request(endpoint, method: method, parameters: parameters, encoding: encoding, headers: headersToSend) }
        
        if validate { dataRequest = dataRequest.validate(statusCode: configuration.acceptableStatusCodes) }

        dataRequest.responseJSON(queue: self.configuration.responseQueue) { alamofireResponse in
            
            let json: JSON? = {
                
                guard let data = alamofireResponse.data, let json = try? JSONSerialization.jsonObject(with: data, options: []) else { return nil }
                return json as? JSON
            }()
            
            let error = alamofireResponse.result.error
            
            EtagManager.storeEtag(endpoint: endpoint, method: method, etagEnabled: etagEnabled, response: alamofireResponse)
            
            response(json, error)
        }
        
        return dataRequest
    }
    
    @discardableResult
    public func request(on endpoint: URLConvertible, method: HTTPMethod = .get, parameters: Parameters? = nil, encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders? = nil, validate: Bool = true, etagEnabled: Bool = false, response: @escaping JSONArrayResponse) -> DataRequest {
        
        let headersToSend = EtagManager.headersFrom(endpoint: endpoint, method: method, etagEnabled: etagEnabled, headers: headers)

        var dataRequest: DataRequest
        
        if etagEnabled && method == .get { dataRequest = self.configuration.sessionManager.requestWithoutCache(endpoint, method: method, parameters: parameters, encoding: encoding, headers: headersToSend) }
            
        else { dataRequest = self.configuration.sessionManager.request(endpoint, method: method, parameters: parameters, encoding: encoding, headers: headersToSend) }
        
        if validate { dataRequest = dataRequest.validate(statusCode: configuration.acceptableStatusCodes) }

        dataRequest.responseJSON(queue: self.configuration.responseQueue) { alamofireResponse in
            
            let array = alamofireResponse.result.value as? Array<JSON>
            let error = alamofireResponse.result.error
            
            EtagManager.storeEtag(endpoint: endpoint, method: method, etagEnabled: etagEnabled, response: alamofireResponse)
            
            response(array, error)
        }
        
        return dataRequest
    }
}

extension Bryce {
    
    @discardableResult
    public func request<E: Encodable>(on endpoint: URLConvertible, method: HTTPMethod = .get, parameters: E, encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders? = nil, validate: Bool = true, etagEnabled: Bool = false, response: @escaping ErrorResponse) -> DataRequest {
        
        let params = try! parameters.parameters(using: self.configuration.requestEncoder)
        
        return request(on: endpoint, method: method, parameters: params, encoding: encoding, headers: headers, validate: validate, etagEnabled: etagEnabled, response: response)
    }
    
    @discardableResult
    public func request<E: Encodable>(on endpoint: URLConvertible, method: HTTPMethod = .get, parameters: E, encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders? = nil, validate: Bool = true, etagEnabled: Bool = false, response: @escaping JSONResponse) -> DataRequest {
        
        let params = try! parameters.parameters(using: self.configuration.requestEncoder)
        
        return request(on: endpoint, method: method, parameters: params, encoding: encoding, headers: headers, validate: validate, etagEnabled: etagEnabled, response: response)
    }
    
    @discardableResult
    public func request<E: Encodable>(on endpoint: URLConvertible, method: HTTPMethod = .get, parameters: E, encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders? = nil, validate: Bool = true, etagEnabled: Bool = false, response: @escaping JSONArrayResponse) -> DataRequest {
        
        let params = try! parameters.parameters(using: self.configuration.requestEncoder)
        
        return request(on: endpoint, method: method, parameters: params, encoding: encoding, headers: headers, validate: validate, etagEnabled: etagEnabled, response: response)
    }
}

extension Bryce {
    
    @discardableResult
    public func request<D: Decodable>(on endpoint: URLConvertible, method: HTTPMethod = .get, parameters: Parameters? = nil, encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders? = nil, validate: Bool = true, etagEnabled: Bool = false, response: @escaping DecodableResponse<D>) -> DataRequest {
        
        let headersToSend = EtagManager.headersFrom(endpoint: endpoint, method: method, etagEnabled: etagEnabled, headers: headers)
        
        var dataRequest: DataRequest
        
        if etagEnabled && method == .get { dataRequest = self.configuration.sessionManager.requestWithoutCache(endpoint, method: method, parameters: parameters, encoding: encoding, headers: headersToSend) }
            
        else { dataRequest = self.configuration.sessionManager.request(endpoint, method: method, parameters: parameters, encoding: encoding, headers: headersToSend) }
        
        if validate { dataRequest = dataRequest.validate(statusCode: configuration.acceptableStatusCodes) }

        dataRequest.responseDecodableObject(queue: self.configuration.responseQueue, decoder: self.configuration.responseDecoder) { (alamofireResponse: DataResponse<D>) in
            
            let decodable = alamofireResponse.result.value
            let error = alamofireResponse.result.error
            
            EtagManager.storeEtag(endpoint: endpoint, method: method, etagEnabled: etagEnabled, response: alamofireResponse)
            
            response(decodable, error)
        }
        
        return dataRequest
    }
    
    @discardableResult
    public func request<E: Encodable, D: Decodable>(on endpoint: URLConvertible, method: HTTPMethod = .get, parameters: E, encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders? = nil, validate: Bool = true, etagEnabled: Bool = false, response: @escaping DecodableResponse<D>) -> DataRequest {
        
        let params = try! parameters.parameters(using: self.configuration.requestEncoder)
        
        return request(on: endpoint, method: method, parameters: params, encoding: encoding, headers: headers, validate: validate, etagEnabled: etagEnabled, response: response)
    }
}

extension Alamofire.SessionManager{
    @discardableResult
    open func requestWithoutCache(
        _ url: URLConvertible,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        encoding: ParameterEncoding = URLEncoding.default,
        headers: HTTPHeaders? = nil)// also you can add URLRequest.CachePolicy here as parameter
        -> DataRequest
    {
        do {
            var urlRequest = try URLRequest(url: url, method: method, headers: headers)
            urlRequest.cachePolicy = .reloadIgnoringCacheData // <<== Cache disabled
            let encodedURLRequest = try encoding.encode(urlRequest, with: parameters)
            return request(encodedURLRequest)
        } catch {
            return request("")
        }
    }
}
