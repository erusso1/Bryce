//
//  File.swift
//  
//
//  Created by Ephraim Russo on 6/26/21.
//

import Foundation
import Bryce
import Combine

protocol PostWebService: WebService {
    
    func getPostsPublisher() -> AnyPublisher<Post, Error>
    
    func getPosts(completion: (Result<Post, Error>) -> Void)
}

struct ConcretePostWebService: PostWebService {
    
    @Endpoint
    private var posts = "/posts"
    
    var client: WebClient = .init()
        
    func getPostsPublisher() -> AnyPublisher<Post, Error> {
        
        //client.get(endpoint: $posts)
        
        Just(Post.fixtures[0])
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func getPosts(completion: (Result<Post, Error>) -> Void) {
        
        completion(.success(Post.fixtures[0]))
    }
}
