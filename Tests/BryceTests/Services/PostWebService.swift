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
    
    func getPost(id: Post.ID) -> WebPublished<Post>
    
    func getPosts(completion: (Result<[Post], Error>) -> Void)
}

struct APIPostWebService: PostWebService {
    
    enum PostURIParameterKey: String, URIParameterKey {
        
        case postId = "post_id"
        case commentId = "comment_id"
    }
    
    @Endpoint
    var posts = "/posts"
    
    @Endpoint<PostURIParameterKey>
    var post = "/posts/:post_id"
    
    @Endpoint<PostURIParameterKey>
    var postComment = "/posts/:post_id/comments/:comment_id"
    
    let client: WebClient = .init(urlString: "https://jsonplaceholder.typicode.com")
        
    func getPostsPublisher() -> WebPublished<[Post]> {

        client.get($posts)
    }
    
    func getPost(id: Post.ID) -> WebPublished<Post> {
        
        client.get($post.uri(.postId, 1))
    }
    
    func getPosts(completion: (Result<[Post], Error>) -> Void) {
        
        completion(.success(Post.fixtures))
    }
}

struct BasicPostWebService: PostWebService {
    
    let client: WebClient = .init()
    
    func getPostsPublisher() -> WebPublished<[Post]> {
        
        Just(Post.fixtures)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func getPost(id: Post.ID) -> WebPublished<Post> {
        
        Just(Post.fixtures[0])
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func getPosts(completion: (Result<[Post], Error>) -> Void) {
        
        completion(.success(Post.fixtures))
    }
}
