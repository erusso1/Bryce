//
//  Request.swift
//  Bryce
//
//  Created by Ephraim Russo on 1/22/19.
//

import Foundation
import Alamofire
import CodableAlamofire

public typealias ErrorResponse = (Error?) -> Void

public typealias JSONResponse = (JSON?, Error?) -> Void

public typealias JSONArrayResponse = (Array<JSON>?, Error?) -> Void

public typealias DecodableResponse<D: Decodable> = (D?, Error?) -> Void

extension Bryce {
    
    @discardableResult
    public func request(on endpoint: URLConvertible, method: HTTPMethod = .get, parameters: Parameters? = nil, encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders? = nil, validate: Bool = false, response: @escaping ErrorResponse) -> DataRequest {
        
        var dataRequest = self.configuration.sessionManager.request(endpoint, method: method, parameters: parameters, encoding: encoding, headers: headers)
            
        if validate { dataRequest = dataRequest.validate() }
            
        dataRequest.response(queue: self.configuration.responseQueue) { alamofireResponse in
            
            let error = alamofireResponse.error
            
            response(error)
        }
        
        return dataRequest
    }
    
    @discardableResult
    public func request(on endpoint: URLConvertible, method: HTTPMethod = .get, parameters: Parameters? = nil, encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders? = nil, validate: Bool = false, response: @escaping JSONResponse) -> DataRequest {
        
        var dataRequest = self.configuration.sessionManager.request(endpoint, method: method, parameters: parameters, encoding: encoding, headers: headers)
            
        if validate { dataRequest = dataRequest.validate() }

        dataRequest.responseJSON(queue: self.configuration.responseQueue) { alamofireResponse in
            
            let json = alamofireResponse.result.value as? [String : Any]
            let error = alamofireResponse.result.error
            
            response(json, error)
        }
        
        return dataRequest
    }
    
    @discardableResult
    public func request(on endpoint: URLConvertible, method: HTTPMethod = .get, parameters: Parameters? = nil, encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders? = nil, validate: Bool = false, response: @escaping JSONArrayResponse) -> DataRequest {
        
        var dataRequest = self.configuration.sessionManager.request(endpoint, method: method, parameters: parameters, encoding: encoding, headers: headers)
            
        if validate { dataRequest = dataRequest.validate() }

        dataRequest.responseJSON(queue: self.configuration.responseQueue) { alamofireResponse in
            
            let array = alamofireResponse.result.value as? Array<[String : Any]>
            let error = alamofireResponse.result.error
            
            response(array, error)
        }
        
        return dataRequest
    }
}

extension Bryce {
    
    @discardableResult
    public func request<E: Encodable>(on endpoint: URLConvertible, method: HTTPMethod = .get, parameters: E, encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders? = nil, validate: Bool = false, response: @escaping ErrorResponse) -> DataRequest {
        
        let params = try! parameters.parameters(using: self.configuration.requestEncoder)
        
        return request(on: endpoint, method: method, parameters: params, encoding: encoding, headers: headers, validate: validate, response: response)
    }
    
    @discardableResult
    public func request<E: Encodable>(on endpoint: URLConvertible, method: HTTPMethod = .get, parameters: E, encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders? = nil, validate: Bool = false, response: @escaping JSONResponse) -> DataRequest {
        
        let params = try! parameters.parameters(using: self.configuration.requestEncoder)
        
        return request(on: endpoint, method: method, parameters: params, encoding: encoding, headers: headers, validate: validate, response: response)
    }
    
    @discardableResult
    public func request<E: Encodable>(on endpoint: URLConvertible, method: HTTPMethod = .get, parameters: E, encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders? = nil, validate: Bool = false, response: @escaping JSONArrayResponse) -> DataRequest {
        
        let params = try! parameters.parameters(using: self.configuration.requestEncoder)
        
        return request(on: endpoint, method: method, parameters: params, encoding: encoding, headers: headers, validate: validate, response: response)
    }
}

extension Bryce {
    
    @discardableResult
    public func request<D: Decodable>(on endpoint: URLConvertible, method: HTTPMethod = .get, parameters: Parameters? = nil, encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders? = nil, validate: Bool = false, response: @escaping DecodableResponse<D>) -> DataRequest {
        
        var dataRequest = self.configuration.sessionManager.request(endpoint, method: method, parameters: parameters, encoding: encoding, headers: headers)
            
        if validate { dataRequest = dataRequest.validate() }

        dataRequest.responseDecodableObject(queue: self.configuration.responseQueue, decoder: self.configuration.responseDecoder) { (alamofireResponse: DataResponse<D>) in
            
            let decodable = alamofireResponse.result.value
            let error = alamofireResponse.result.error
            
            response(decodable, error)
        }
        
        return dataRequest
    }
    
    @discardableResult
    public func request<E: Encodable, D: Decodable>(on endpoint: URLConvertible, method: HTTPMethod = .get, parameters: E, encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders? = nil, validate: Bool = false, response: @escaping DecodableResponse<D>) -> DataRequest {
        
        let params = try! parameters.parameters(using: self.configuration.requestEncoder)
        
        return request(on: endpoint, method: method, parameters: params, encoding: encoding, headers: headers, validate: validate, response: response)
    }
}
