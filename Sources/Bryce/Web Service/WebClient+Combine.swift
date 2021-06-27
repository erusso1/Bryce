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
}

extension WebClient {
    
    public func get<E: Encodable, D: Decodable>(_ path: String, parameters: E?, headers: HTTPHeaders? = nil) -> WebPublished<D> {
        
        session
            .request(endpoint(path: path), method: .get, parameters: parameters, headers: requestHeaders(from: headers))
            .publishDecodable(queue: responseQueue, decoder: responseDecoder)
            .tryCompactMap(mapOutput)
            .eraseToAnyPublisher()
    }
    
    public func get<D: Decodable>(_ path: String, headers: HTTPHeaders? = nil) -> WebPublished<D> {
        
        session
            .request(endpoint(path: path), method: .get, headers: requestHeaders(from: headers))
            .publishDecodable(queue: responseQueue, decoder: responseDecoder)
            .tryCompactMap(mapOutput)
            .eraseToAnyPublisher()
    }
    
    public func post<E: Encodable, D: Decodable>(_ path: String, parameters: E?, headers: HTTPHeaders? = nil) -> WebPublished<D> {
        
        session
            .request(endpoint(path: path), method: .post, parameters: parameters, headers: requestHeaders(from: headers))
            .publishDecodable(queue: responseQueue, decoder: responseDecoder)
            .tryCompactMap(mapOutput)
            .eraseToAnyPublisher()
    }
    
    public func post<D: Decodable>(_ path: String, headers: HTTPHeaders? = nil) -> WebPublished<D> {
        
        session
            .request(endpoint(path: path), method: .post, headers: requestHeaders(from: headers))
            .publishDecodable(queue: responseQueue, decoder: responseDecoder)
            .tryCompactMap(mapOutput)
            .eraseToAnyPublisher()
    }
    
    public func post<E: Encodable>(_ path: String, parameters: E?, headers: HTTPHeaders? = nil) -> WebPublished<Void> {
        
        session
            .request(endpoint(path: path), method: .post, parameters: parameters, headers: requestHeaders(from: headers))
            .publishUnserialized(queue: responseQueue)
            .tryCompactMap(mapOutput)
            .eraseToAnyPublisher()
    }
    
    public func post(_ path: String, headers: HTTPHeaders? = nil) -> WebPublished<Void> {
        
        session
            .request(endpoint(path: path), method: .post, headers: requestHeaders(from: headers))
            .publishUnserialized(queue: responseQueue)
            .tryCompactMap(mapOutput)
            .eraseToAnyPublisher()
    }
    
    public func put<E: Encodable, D: Decodable>(_ path: String, parameters: E?, headers: HTTPHeaders? = nil) -> WebPublished<D> {
        
        session
            .request(endpoint(path: path), method: .put, parameters: parameters, headers: requestHeaders(from: headers))
            .publishDecodable(queue: responseQueue, decoder: responseDecoder)
            .tryCompactMap(mapOutput)
            .eraseToAnyPublisher()
    }
    
    public func put<D: Decodable>(_ path: String, headers: HTTPHeaders? = nil) -> WebPublished<D> {
        
        session
            .request(endpoint(path: path), method: .put, headers: requestHeaders(from: headers))
            .publishDecodable(queue: responseQueue, decoder: responseDecoder)
            .tryCompactMap(mapOutput)
            .eraseToAnyPublisher()
    }
    
    public func patch<E: Encodable, D: Decodable>(_ path: String, parameters: E?, headers: HTTPHeaders? = nil) -> WebPublished<D> {
        
        session
            .request(endpoint(path: path), method: .patch, parameters: parameters, headers: requestHeaders(from: headers))
            .publishDecodable(queue: responseQueue, decoder: responseDecoder)
            .tryCompactMap(mapOutput)
            .eraseToAnyPublisher()
    }
    
    public func patch<D: Decodable>(_ path: String, headers: HTTPHeaders? = nil) -> WebPublished<D> {
        
        session
            .request(endpoint(path: path), method: .patch, headers: requestHeaders(from: headers))
            .publishDecodable(queue: responseQueue, decoder: responseDecoder)
            .tryCompactMap(mapOutput)
            .eraseToAnyPublisher()
    }
    
    public func delete<E: Encodable, D: Decodable>(_ path: String, parameters: E?, headers: HTTPHeaders? = nil) -> WebPublished<D> {
        
        session
            .request(endpoint(path: path), method: .delete, parameters: parameters, headers: requestHeaders(from: headers))
            .publishDecodable(queue: responseQueue, decoder: responseDecoder)
            .tryCompactMap(mapOutput)
            .eraseToAnyPublisher()
    }
    
    public func delete<D: Decodable>(_ path: String, headers: HTTPHeaders? = nil) -> WebPublished<D> {
        
        session
            .request(endpoint(path: path), method: .delete, headers: requestHeaders(from: headers))
            .publishDecodable(queue: responseQueue, decoder: responseDecoder)
            .tryCompactMap(mapOutput)
            .eraseToAnyPublisher()
    }
}

extension WebService {
    
    public func get<E: Encodable, D: Decodable>(_ path: String, parameters: E?, headers: HTTPHeaders? = nil) -> WebPublished<D> {
        client.get(path, parameters: parameters, headers: headers)
    }
    
    public func get<D: Decodable>(_ path: String, headers: HTTPHeaders? = nil) -> WebPublished<D> {
        client.get(path, headers: headers)
    }
    
    public func post<E: Encodable, D: Decodable>(_ path: String, parameters: E?, headers: HTTPHeaders? = nil) -> WebPublished<D> {
        client.post(path, parameters: parameters, headers: headers)
    }
    
    public func post<D: Decodable>(_ path: String, headers: HTTPHeaders? = nil) -> WebPublished<D> {
        client.post(path, headers: headers)
    }
    
    public func post<E: Encodable>(_ path: String, parameters: E?, headers: HTTPHeaders? = nil) -> WebPublished<Void> {
        client.post(path, parameters: parameters, headers: headers)
    }
    
    public func post(_ path: String, headers: HTTPHeaders? = nil) -> WebPublished<Void> {
        client.post(path, headers: headers)
    }
    
    public func put<E: Encodable, D: Decodable>(_ path: String, parameters: E?, headers: HTTPHeaders? = nil) -> WebPublished<D> {
        client.put(path, parameters: parameters, headers: headers)
    }
    
    public func put<D: Decodable>(_ path: String, headers: HTTPHeaders? = nil) -> WebPublished<D> {
        client.put(path, headers: headers)
    }
    
    public func patch<E: Encodable, D: Decodable>(_ path: String, parameters: E?, headers: HTTPHeaders? = nil) -> WebPublished<D> {
        client.patch(path, parameters: parameters, headers: headers)
    }
    
    public func patch<D: Decodable>(_ path: String, headers: HTTPHeaders? = nil) -> WebPublished<D> {
        client.patch(path, headers: headers)
    }
    
    public func delete<E: Encodable, D: Decodable>(_ path: String, parameters: E?, headers: HTTPHeaders? = nil) -> WebPublished<D> {
        client.delete(path, parameters: parameters, headers: headers)
    }
    
    public func delete<D: Decodable>(_ path: String, headers: HTTPHeaders? = nil) -> WebPublished<D> {
        client.delete(path, headers: headers)
    }
}

private extension WebClient {
    
    func mapOutput(_ output: DataResponsePublisher<Data?>.Output) throws {
        if let error = output.error?.underlyingError {
            throw error
        }
    }
    
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
