//
//  File.swift
//  
//
//  Created by Ephraim Russo on 6/26/21.
//

import Foundation
import Alamofire
import Combine

public typealias WebPublished<T> = AnyPublisher<T, Error>

extension WebClient {
    
    public enum Error: Swift.Error {
        case unknown
    }
    
    public func get<E: Encodable, D: Decodable>(_ endpoint: Endpoint, parameters: E?, headers: HTTPHeaders? = nil) -> AnyPublisher<D, Swift.Error> {
        
        session
            .request(url(endpoint: endpoint), method: .get, parameters: parameters, headers: requestHeaders(from: headers))
            .publishDecodable(queue: responseQueue, decoder: responseDecoder)
            .tryCompactMap(mapOutput)
            .eraseToAnyPublisher()
    }
    
    public func get<D: Decodable>(_ endpoint: Endpoint, headers: HTTPHeaders? = nil) -> AnyPublisher<D, Swift.Error> {
        
        session
            .request(url(endpoint: endpoint), method: .get, headers: requestHeaders(from: headers))
            .publishDecodable(queue: responseQueue, decoder: responseDecoder)
            .tryCompactMap(mapOutput)
            .eraseToAnyPublisher()
    }
    
    public func post<E: Encodable, D: Decodable>(_ endpoint: Endpoint, parameters: E?, headers: HTTPHeaders? = nil) -> AnyPublisher<D, Swift.Error> {
        
        session
            .request(url(endpoint: endpoint), method: .post, parameters: parameters, headers: requestHeaders(from: headers))
            .publishDecodable(queue: responseQueue, decoder: responseDecoder)
            .tryCompactMap(mapOutput)
            .eraseToAnyPublisher()
    }
}

private extension WebClient {
    
    func mapOutput<D: Decodable>(_ output: DataResponsePublisher<D>.Output) throws -> D {
        
        if let decodable = output.value {
            return decodable
        } else if let error = output.error?.underlyingError {
            throw error
        } else {
            throw Error.unknown
        }
    }
}
