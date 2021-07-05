//
//  File.swift
//  
//
//  Created by Ephraim Russo on 7/4/21.
//

import Foundation
import Alamofire

extension DataResponse where Failure == AFError {
    
    @discardableResult
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
    
    private func decodedError(_ data: Data) -> Swift.Error? {
        
        guard let service = Bryce.decodableErrorService else { return nil }
        
        let decoder = Bryce.config.responseDecoder
        
        do { return try service.decode(data, using: decoder) }
        catch { return error }
    }
}

extension DataResponse where Success: Decodable, Failure == AFError {
    
    func handle(_ completion: WebResult<Success>) {
     
        do {
            let value = try mapOutput()
            completion(.success(value))
        } catch {
            completion(.failure(error))
        }
    }
}
