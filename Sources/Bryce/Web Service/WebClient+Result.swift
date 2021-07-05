//
//  File.swift
//  
//
//  Created by Ephraim Russo on 7/4/21.
//

import Foundation
import Alamofire

public typealias WebResult<T> = (Result<T, Swift.Error>) -> Void

extension WebClient {
    
    public func get<E, D>(_ path: String,
                          parameters: E,
                          headers: HTTPHeaders? = nil,
                          requestModifier: Session.RequestModifier? = nil,
                          completion: @escaping WebResult<D>)
    where E: Encodable, D: Decodable {
        
        session
            .request(endpoint(path: path),
                     method: .get,
                     parameters: parameters,
                     headers: headers)
            .responseDecodable(of: D.self,
                               queue: responseQueue,
                               decoder: responseDecoder)
                { $0.handle(completion) }
    }
    
    public func get<D>(_ path: String,
                       headers: HTTPHeaders? = nil,
                       requestModifier: Session.RequestModifier? = nil,
                       completion: @escaping WebResult<D>)
    where D: Decodable {
        
        session
            .request(endpoint(path: path),
                     method: .get,
                     headers: headers)
            .responseDecodable(of: D.self,
                               queue: responseQueue,
                               decoder: responseDecoder)
                { $0.handle(completion) }
    }
    
    public func post<E, D>(_ path: String,
                           parameters: E,
                           headers: HTTPHeaders? = nil,
                           requestModifier: Session.RequestModifier? = nil,
                           completion: @escaping WebResult<D>)
    where E: Encodable, D: Decodable {
        
        session
            .request(endpoint(path: path),
                     method: .post,
                     parameters: parameters,
                     headers: headers)
            .responseDecodable(of: D.self,
                               queue: responseQueue,
                               decoder: responseDecoder)
                { $0.handle(completion) }
    }
    
    public func post<D>(_ path: String,
                        headers: HTTPHeaders? = nil,
                        requestModifier: Session.RequestModifier? = nil,
                        completion: @escaping WebResult<D>)
    where D: Decodable {
        
        session
            .request(endpoint(path: path),
                     method: .post,
                     headers: headers)
            .responseDecodable(of: D.self,
                               queue: responseQueue,
                               decoder: responseDecoder)
                { $0.handle(completion) }
    }
    
    public func post<E>(_ path: String,
                        parameters: E,
                        headers: HTTPHeaders? = nil,
                        requestModifier: Session.RequestModifier? = nil,
                        completion: @escaping WebResult<Void>)
    where E: Encodable {
        
        session
            .request(endpoint(path: path),
                     method: .post,
                     parameters: parameters,
                     headers: headers)
            .response(queue: responseQueue) { $0.handleVoid(completion) }
    }
}

extension WebService {
    
    public func get<E, D>(_ path: String,
                          parameters: E,
                          headers: HTTPHeaders? = nil,
                          completion: @escaping WebResult<D>)
    where E: Encodable, D: Decodable {
        
        client.get(path,
                   parameters: parameters,
                   headers: headers,
                   requestModifier: requestModifier,
                   completion: completion)
    }
    
    public func get<D>(_ path: String,
                       headers: HTTPHeaders? = nil,
                       completion: @escaping WebResult<D>)
    where D: Decodable {
        
        client.get(path,
                   headers: headers,
                   requestModifier: requestModifier,
                   completion: completion)
    }
    
    func post<E, D>(_ path: String,
                    parameters: E,
                    headers: HTTPHeaders? = nil,
                    requestModifier: Session.RequestModifier? = nil,
                    completion: @escaping WebResult<D>)
    where E: Encodable, D: Decodable {
        
        client.post(path,
                    parameters: parameters,
                    headers: headers,
                    requestModifier: requestModifier,
                    completion: completion)
    }
    
    public func post<D>(_ path: String,
                        headers: HTTPHeaders? = nil,
                        completion: @escaping WebResult<D>)
    where D: Decodable {
        
        client.post(path,
                    headers: headers,
                    requestModifier: requestModifier,
                    completion: completion)
    }
    
    public func post<E>(_ path: String,
                        parameters: E,
                        headers: HTTPHeaders? = nil,
                        requestModifier: Session.RequestModifier? = nil,
                        completion: @escaping WebResult<Void>)
    where E: Encodable {
        
        client.post(path,
                    parameters: parameters,
                    headers: headers,
                    requestModifier: requestModifier,
                    completion: completion)
    }
}
