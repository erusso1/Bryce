//
//  File.swift
//  
//
//  Created by Ephraim Russo on 6/26/21.
//

import Foundation
import Bryce
import Combine
import Alamofire

protocol PostWebService: WebService {
    
    func getPostsPublisher() -> WebPublished<[Post]>
    
    func getPosts(completion: (Result<[Post], Error>) -> Void)
}

struct APIPostWebService: PostWebService {
    
    @Endpoint
    private var posts = "/posts"
    
    let client: WebClient = .init(urlString: "https://jsonplaceholder.typicode.com")
        
    func getPostsPublisher() -> WebPublished<[Post]> {
                
        client.get($posts)
    }
    
    func getPosts(completion: (Result<[Post], Error>) -> Void) {
        
        completion(.success(Post.fixtures))
    }
}

struct OverridingPostWebService: PostWebService {
    
    let client: WebClient = .init(urlString: "https://api.test.com")
    
    func getPostsPublisher() -> WebPublished<[Post]> {
        
        Just(Post.fixtures)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func getPosts(completion: (Result<[Post], Error>) -> Void) {
        
        completion(.success(Post.fixtures))
    }
}
