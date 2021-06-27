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
    
    func getPostsPublisher() -> WebPublished<Post>
    
    func getPosts(completion: (Result<Post, Error>) -> Void)
}

struct ConcretePostWebService: PostWebService {
    
    @Endpoint
    private var posts = "/posts"
    
    var client: WebClient = .init()
        
    func getPostsPublisher() -> WebPublished<Post> {
                
        client.get($posts)
    }
    
    func getPosts(completion: (Result<Post, Error>) -> Void) {
        
        completion(.success(Post.fixtures[0]))
    }
}
