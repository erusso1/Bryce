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
    
    public func get<E: Encodable, D: Decodable>(_ path: String, parameters: E?, headers: HTTPHeaders? = nil, requestModifier: Session.RequestModifier? = nil) -> WebPublished<D> {
        
        session
            .request(endpoint(path: path), method: .get, parameters: parameters, headers: headers)
            .publishDecodable(queue: responseQueue, decoder: responseDecoder)
            .tryCompactMap(mapOutput)
            .eraseToAnyPublisher()
    }
    
    public func get<D: Decodable>(_ path: String, headers: HTTPHeaders? = nil, requestModifier: Session.RequestModifier? = nil) -> WebPublished<D> {
        
        session
            .request(endpoint(path: path), method: .get, headers: headers)
            .publishDecodable(queue: responseQueue, decoder: responseDecoder)
            .tryCompactMap(mapOutput)
            .eraseToAnyPublisher()
    }
    
    public func post<E: Encodable, D: Decodable>(_ path: String, parameters: E?, headers: HTTPHeaders? = nil, requestModifier: Session.RequestModifier? = nil) -> WebPublished<D> {
        
        session
            .request(endpoint(path: path), method: .post, parameters: parameters, headers: headers)
            .publishDecodable(queue: responseQueue, decoder: responseDecoder)
            .tryCompactMap(mapOutput)
            .eraseToAnyPublisher()
    }
    
    public func post<D: Decodable>(_ path: String, headers: HTTPHeaders? = nil, requestModifier: Session.RequestModifier? = nil) -> WebPublished<D> {
        
        session
            .request(endpoint(path: path), method: .post, headers: headers)
            .publishDecodable(queue: responseQueue, decoder: responseDecoder)
            .tryCompactMap(mapOutput)
            .eraseToAnyPublisher()
    }
    
    public func post<E: Encodable>(_ path: String, parameters: E?, headers: HTTPHeaders? = nil, requestModifier: Session.RequestModifier? = nil) -> WebPublished<Void> {
        
        session
            .request(endpoint(path: path), method: .post, parameters: parameters, headers: headers)
            .publishUnserialized(queue: responseQueue)
            .tryCompactMap(mapOutput)
            .eraseToAnyPublisher()
    }
    
    public func post(_ path: String, headers: HTTPHeaders? = nil, requestModifier: Session.RequestModifier? = nil) -> WebPublished<Void> {
        
        session
            .request(endpoint(path: path), method: .post, headers: headers)
            .publishUnserialized(queue: responseQueue)
            .tryCompactMap(mapOutput)
            .eraseToAnyPublisher()
    }
    
    public func put<E: Encodable, D: Decodable>(_ path: String, parameters: E?, headers: HTTPHeaders? = nil, requestModifier: Session.RequestModifier? = nil) -> WebPublished<D> {
        
        session
            .request(endpoint(path: path), method: .put, parameters: parameters, headers: headers)
            .publishDecodable(queue: responseQueue, decoder: responseDecoder)
            .tryCompactMap(mapOutput)
            .eraseToAnyPublisher()
    }
    
    public func put<D: Decodable>(_ path: String, headers: HTTPHeaders? = nil, requestModifier: Session.RequestModifier? = nil) -> WebPublished<D> {
        
        session
            .request(endpoint(path: path), method: .put, headers: headers)
            .publishDecodable(queue: responseQueue, decoder: responseDecoder)
            .tryCompactMap(mapOutput)
            .eraseToAnyPublisher()
    }
    
    public func patch<E: Encodable, D: Decodable>(_ path: String, parameters: E?, headers: HTTPHeaders? = nil, requestModifier: Session.RequestModifier? = nil) -> WebPublished<D> {
        
        session
            .request(endpoint(path: path), method: .patch, parameters: parameters, headers: headers)
            .publishDecodable(queue: responseQueue, decoder: responseDecoder)
            .tryCompactMap(mapOutput)
            .eraseToAnyPublisher()
    }
    
    public func patch<D: Decodable>(_ path: String, headers: HTTPHeaders? = nil, requestModifier: Session.RequestModifier? = nil) -> WebPublished<D> {
        
        session
            .request(endpoint(path: path), method: .patch, headers: headers)
            .publishDecodable(queue: responseQueue, decoder: responseDecoder)
            .tryCompactMap(mapOutput)
            .eraseToAnyPublisher()
    }
    
    public func delete<E: Encodable, D: Decodable>(_ path: String, parameters: E?, headers: HTTPHeaders? = nil, requestModifier: Session.RequestModifier? = nil) -> WebPublished<D> {
        
        session
            .request(endpoint(path: path), method: .delete, parameters: parameters, headers: headers)
            .publishDecodable(queue: responseQueue, decoder: responseDecoder)
            .tryCompactMap(mapOutput)
            .eraseToAnyPublisher()
    }
    
    public func delete<D: Decodable>(_ path: String, headers: HTTPHeaders? = nil, requestModifier: Session.RequestModifier? = nil) -> WebPublished<D> {
        
        session
            .request(endpoint(path: path), method: .delete, headers: headers, requestModifier: requestModifier)
            .publishDecodable(queue: responseQueue, decoder: responseDecoder)
            .tryCompactMap(mapOutput)
            .eraseToAnyPublisher()
    }
}

extension WebService {
    
    public func get<E: Encodable, D: Decodable>(_ path: String, parameters: E?, headers: HTTPHeaders? = nil) -> WebPublished<D> {
        client.get(path, parameters: parameters, headers: headers, requestModifier: requestModifier)
    }
    
    public func get<D: Decodable>(_ path: String, headers: HTTPHeaders? = nil) -> WebPublished<D> {
        client.get(path, headers: headers, requestModifier: requestModifier)
    }
    
    public func post<E: Encodable, D: Decodable>(_ path: String, parameters: E?, headers: HTTPHeaders? = nil) -> WebPublished<D> {
        client.post(path, parameters: parameters, headers: headers, requestModifier: requestModifier)
    }
    
    public func post<D: Decodable>(_ path: String, headers: HTTPHeaders? = nil) -> WebPublished<D> {
        client.post(path, headers: headers, requestModifier: requestModifier)
    }
    
    public func post<E: Encodable>(_ path: String, parameters: E?, headers: HTTPHeaders? = nil) -> WebPublished<Void> {
        client.post(path, parameters: parameters, headers: headers, requestModifier: requestModifier)
    }
    
    public func post(_ path: String, headers: HTTPHeaders? = nil) -> WebPublished<Void> {
        client.post(path, headers: headers, requestModifier: requestModifier)
    }
    
    public func put<E: Encodable, D: Decodable>(_ path: String, parameters: E?, headers: HTTPHeaders? = nil) -> WebPublished<D> {
        client.put(path, parameters: parameters, headers: headers, requestModifier: requestModifier)
    }
    
    public func put<D: Decodable>(_ path: String, headers: HTTPHeaders? = nil) -> WebPublished<D> {
        client.put(path, headers: headers, requestModifier: requestModifier)
    }
    
    public func patch<E: Encodable, D: Decodable>(_ path: String, parameters: E?, headers: HTTPHeaders? = nil) -> WebPublished<D> {
        client.patch(path, parameters: parameters, headers: headers, requestModifier: requestModifier)
    }
    
    public func patch<D: Decodable>(_ path: String, headers: HTTPHeaders? = nil) -> WebPublished<D> {
        client.patch(path, headers: headers, requestModifier: requestModifier)
    }
    
    public func delete<E: Encodable, D: Decodable>(_ path: String, parameters: E?, headers: HTTPHeaders? = nil) -> WebPublished<D> {
        client.delete(path, parameters: parameters, headers: headers, requestModifier: requestModifier)
    }
    
    public func delete<D: Decodable>(_ path: String, headers: HTTPHeaders? = nil) -> WebPublished<D> {
        client.delete(path, headers: headers, requestModifier: requestModifier)
    }
}

private extension WebClient {
    
    func mapOutput(_ output: DataResponsePublisher<Data?>.Output) throws {
        if let error = output.error?.underlyingError {
            if let data = output.data, let decodedError = decodedError(data) {
                // attempt to decode as decodable error.
                throw decodedError
            } else {
                // otherwise throw the error that was given.
                throw error
            }
        }
    }
    
    func mapOutput<D: Decodable>(_ output: DataResponsePublisher<D>.Output) throws -> D {
        
        if let decodable = output.value {
            return decodable
        } else if let error = output.error {
            if let data = output.data, let decodedError = decodedError(data) {
                // attempt to decode as decodable error.
                throw decodedError
            } else {
                // otherwise throw the error that was given.
                throw error.underlyingError ?? error
            }
        } else {
            throw Error.unknown
        }
    }
}

func decodedError(_ data: Data) -> Swift.Error? {
    
    guard let service = Bryce.decodableErrorService else { return nil }
    
    let decoder = Bryce.config.responseDecoder
    
    do { return try service.decode(data, using: decoder) }
    catch { return error }
}
