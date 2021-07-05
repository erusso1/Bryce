//
//  File.swift
//  
//
//  Created by Ephraim Russo on 7/4/21.
//

import Foundation
import Alamofire

public typealias WebResult<T: Decodable> = (Result<T, Swift.Error>) -> Void

extension WebClient {
    
    public func get<E: Encodable, D: Decodable>(_ path: String, parameters: E?, headers: HTTPHeaders? = nil, requestModifier: Session.RequestModifier? = nil, completion: @escaping WebResult<D>) {
        
        session
            .request(endpoint(path: path), method: .get, parameters: parameters, headers: headers)
            .responseDecodable(of: D.self, queue: responseQueue, decoder: responseDecoder) { $0.handle(completion) }
    }
}

private extension DataResponse where Success: Decodable, Failure == AFError {
    
    func handle(_ completion: WebResult<Success>) {
     
        do {
            let value = try mapOutput()
            completion(.success(value))
        } catch {
            completion(.failure(error))
        }
    }
    
    func mapOutput() throws -> Success {
        
        if let decodable = value {
            return decodable
        } else if let error = error {
            if let data = data, let decodedError = decodedError(data) {
                // attempt to decode as decodable error.
                throw decodedError
            } else {
                // otherwise throw the error that was given.
                throw error.underlyingError ?? error
            }
        } else {
            throw WebClient.Error.unknown
        }
    }
}

private extension WebClient {
    
    func mapOutput<D: Decodable>(_ output: DataResponse<D, AFError>) throws -> D {
        
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
