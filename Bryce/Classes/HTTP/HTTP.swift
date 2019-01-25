//
//  Request.swift
//  Bryce
//
//  Created by Ephraim Russo on 1/22/19.
//

import Foundation
import Alamofire
import CodableAlamofire

public typealias JSONResponse = (JSON?, Error?) -> Void

public typealias JSONArrayResponse = (Array<JSON>?, Error?) -> Void

public typealias DecodableResponse<D: Decodable> = (D?, Error?) -> Void

extension Bryce {
    
    public func request(on endpoint: URLConvertible, method: HTTPMethod = .get, parameters: Parameters? = nil, encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders? = nil, response: @escaping JSONResponse) {
        
        Bryce.shared.configuration.sessionManager.request(endpoint, method: method, parameters: parameters, encoding: encoding, headers: headers).validate().responseJSON(queue: Bryce.shared.configuration.responseQueue) { alamofireResponse in
            
            let json = alamofireResponse.result.value as? [String : Any]
            let error = alamofireResponse.result.error
            
            response(json, error)
        }
    }
    
    public func request(on endpoint: URLConvertible, method: HTTPMethod = .get, parameters: Parameters? = nil, encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders? = nil, response: @escaping JSONArrayResponse) {
        
        Bryce.shared.configuration.sessionManager.request(endpoint, method: method, parameters: parameters, encoding: encoding, headers: headers).validate().responseJSON(queue: Bryce.shared.configuration.responseQueue) { alamofireResponse in
            
            let array = alamofireResponse.result.value as? Array<[String : Any]>
            let error = alamofireResponse.result.error
            
            response(array, error)
        }
    }
    
    public func request<D: Decodable>(on endpoint: URLConvertible, method: HTTPMethod = .get, parameters: Parameters? = nil, encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders? = nil, response: @escaping DecodableResponse<D>) {
        
        Bryce.shared.configuration.sessionManager.request(endpoint, method: method, parameters: parameters, encoding: encoding, headers: headers).validate().responseDecodableObject(queue: Bryce.shared.configuration.responseQueue, decoder: Bryce.shared.configuration.responseDecoder) { (alamofireResponse: DataResponse<D>) in
            
            let decodable = alamofireResponse.result.value
            let error = alamofireResponse.result.error
            
            response(decodable, error)
        }
    }
    
    public func request<E: Encodable, D: Decodable>(on endpoint: URLConvertible, method: HTTPMethod = .get, parameters: E, encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders? = nil, response: @escaping DecodableResponse<D>) {
        
        do {
            
            let data = try Bryce.shared.configuration.requestEncoder.encode(parameters)
            
            guard let params = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] else { throw EncodingError.invalidValue(parameters, .init(codingPath: [], debugDescription: "Unable to encode parameters: \(parameters)")) }
            
            request(on: endpoint, method: method, parameters: params, encoding: encoding, headers: headers, response: response)
        }
            
        catch { return response(nil, error) }
    }
}

