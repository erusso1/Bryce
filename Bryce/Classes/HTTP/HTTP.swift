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
    public func request(on endpoint: URLConvertible, method: HTTPMethod = .get, parameters: Parameters? = nil, encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders? = nil, validate: Bool = false, etagEnabled: Bool = false, response: @escaping DefaultAlamofireResponse) -> DataRequest {
        
        let headersToSend = EtagManager.headersFrom(endpoint: endpoint, method: method, etagEnabled: etagEnabled, headers: headers)
        
        var dataRequest = self.configuration.sessionManager.request(endpoint, method: method, parameters: parameters, encoding: encoding, headers: headersToSend)
        
        if validate { dataRequest = dataRequest.validate() }
        
        dataRequest.response(queue: self.configuration.responseQueue) { alamofireResponse in
            
            EtagManager.storeEtag(endpoint: endpoint, method: method, etagEnabled: etagEnabled, response: alamofireResponse)
            
            response(alamofireResponse)
        }
        
        return dataRequest
    }
    
    @discardableResult
    public func request(on endpoint: URLConvertible, method: HTTPMethod = .get, parameters: Parameters? = nil, encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders? = nil, validate: Bool = false, etagEnabled: Bool = false, response: @escaping ErrorResponse) -> DataRequest {
        
        let headersToSend = EtagManager.headersFrom(endpoint: endpoint, method: method, etagEnabled: etagEnabled, headers: headers)

        var dataRequest = self.configuration.sessionManager.request(endpoint, method: method, parameters: parameters, encoding: encoding, headers: headersToSend)
            
        if validate { dataRequest = dataRequest.validate() }
            
        dataRequest.response(queue: self.configuration.responseQueue) { alamofireResponse in
            
            let error = alamofireResponse.error
            
            EtagManager.storeEtag(endpoint: endpoint, method: method, etagEnabled: etagEnabled, response: alamofireResponse)
            
            response(error)
        }
        
        return dataRequest
    }
    
    @discardableResult
    public func request(on endpoint: URLConvertible, method: HTTPMethod = .get, parameters: Parameters? = nil, encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders? = nil, validate: Bool = false, etagEnabled: Bool = false, response: @escaping JSONAlamofireResponse) -> DataRequest {
        
        let headersToSend = EtagManager.headersFrom(endpoint: endpoint, method: method, etagEnabled: etagEnabled, headers: headers)

        var dataRequest = self.configuration.sessionManager.request(endpoint, method: method, parameters: parameters, encoding: encoding, headers: headersToSend)
        
        if validate { dataRequest = dataRequest.validate() }
        
        dataRequest.responseJSON(queue: self.configuration.responseQueue) { alamofireResponse in
            
            EtagManager.storeEtag(endpoint: endpoint, method: method, etagEnabled: etagEnabled, response: alamofireResponse)
            
            response(alamofireResponse)
        }
        
        return dataRequest
    }
    
    @discardableResult
    public func request(on endpoint: URLConvertible, method: HTTPMethod = .get, parameters: Parameters? = nil, encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders? = nil, validate: Bool = false, etagEnabled: Bool = false, response: @escaping JSONResponse) -> DataRequest {
        
        let headersToSend = EtagManager.headersFrom(endpoint: endpoint, method: method, etagEnabled: etagEnabled, headers: headers)
        
        var dataRequest = self.configuration.sessionManager.request(endpoint, method: method, parameters: parameters, encoding: encoding, headers: headersToSend)
            
        if validate { dataRequest = dataRequest.validate() }

        dataRequest.responseJSON(queue: self.configuration.responseQueue) { alamofireResponse in
            
            let json = alamofireResponse.result.value as? [String : Any]
            let error = alamofireResponse.result.error
            
            EtagManager.storeEtag(endpoint: endpoint, method: method, etagEnabled: etagEnabled, response: alamofireResponse)
            
            response(json, error)
        }
        
        return dataRequest
    }
    
    @discardableResult
    public func request(on endpoint: URLConvertible, method: HTTPMethod = .get, parameters: Parameters? = nil, encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders? = nil, validate: Bool = false, etagEnabled: Bool = false, response: @escaping JSONArrayResponse) -> DataRequest {
        
        let headersToSend = EtagManager.headersFrom(endpoint: endpoint, method: method, etagEnabled: etagEnabled, headers: headers)

        var dataRequest = self.configuration.sessionManager.request(endpoint, method: method, parameters: parameters, encoding: encoding, headers: headersToSend)
            
        if validate { dataRequest = dataRequest.validate() }

        dataRequest.responseJSON(queue: self.configuration.responseQueue) { alamofireResponse in
            
            let array = alamofireResponse.result.value as? Array<[String : Any]>
            let error = alamofireResponse.result.error
            
            EtagManager.storeEtag(endpoint: endpoint, method: method, etagEnabled: etagEnabled, response: alamofireResponse)
            
            response(array, error)
        }
        
        return dataRequest
    }
}

extension Bryce {
    
    @discardableResult
    public func request<E: Encodable>(on endpoint: URLConvertible, method: HTTPMethod = .get, parameters: E, encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders? = nil, validate: Bool = false, etagEnabled: Bool = false, response: @escaping ErrorResponse) -> DataRequest {
        
        let params = try! parameters.parameters(using: self.configuration.requestEncoder)
        
        return request(on: endpoint, method: method, parameters: params, encoding: encoding, headers: headers, validate: validate, etagEnabled: etagEnabled, response: response)
    }
    
    @discardableResult
    public func request<E: Encodable>(on endpoint: URLConvertible, method: HTTPMethod = .get, parameters: E, encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders? = nil, validate: Bool = false, etagEnabled: Bool = false, response: @escaping JSONResponse) -> DataRequest {
        
        let params = try! parameters.parameters(using: self.configuration.requestEncoder)
        
        return request(on: endpoint, method: method, parameters: params, encoding: encoding, headers: headers, validate: validate, etagEnabled: etagEnabled, response: response)
    }
    
    @discardableResult
    public func request<E: Encodable>(on endpoint: URLConvertible, method: HTTPMethod = .get, parameters: E, encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders? = nil, validate: Bool = false, etagEnabled: Bool = false, response: @escaping JSONArrayResponse) -> DataRequest {
        
        let params = try! parameters.parameters(using: self.configuration.requestEncoder)
        
        return request(on: endpoint, method: method, parameters: params, encoding: encoding, headers: headers, validate: validate, etagEnabled: etagEnabled, response: response)
    }
}

extension Bryce {
    
    @discardableResult
    public func request<D: Decodable>(on endpoint: URLConvertible, method: HTTPMethod = .get, parameters: Parameters? = nil, encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders? = nil, validate: Bool = false, etagEnabled: Bool = false, response: @escaping DecodableResponse<D>) -> DataRequest {
        
        let headersToSend = EtagManager.headersFrom(endpoint: endpoint, method: method, etagEnabled: etagEnabled, headers: headers)
        
        var dataRequest = self.configuration.sessionManager.request(endpoint, method: method, parameters: parameters, encoding: encoding, headers: headersToSend)
            
        if validate { dataRequest = dataRequest.validate() }

        dataRequest.responseDecodableObject(queue: self.configuration.responseQueue, decoder: self.configuration.responseDecoder) { (alamofireResponse: DataResponse<D>) in
            
            let decodable = alamofireResponse.result.value
            let error = alamofireResponse.result.error
            
            EtagManager.storeEtag(endpoint: endpoint, method: method, etagEnabled: etagEnabled, response: alamofireResponse)
            
            response(decodable, error)
        }
        
        return dataRequest
    }
    
    @discardableResult
    public func request<E: Encodable, D: Decodable>(on endpoint: URLConvertible, method: HTTPMethod = .get, parameters: E, encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders? = nil, validate: Bool = false, etagEnabled: Bool = false, response: @escaping DecodableResponse<D>) -> DataRequest {
        
        let params = try! parameters.parameters(using: self.configuration.requestEncoder)
        
        return request(on: endpoint, method: method, parameters: params, encoding: encoding, headers: headers, validate: validate, etagEnabled: etagEnabled, response: response)
    }
}
