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

protocol PostWebService {
    
    func getPostsPublisher() -> WebPublished<[Post]>
    
    func getPost(id: Post.ID) -> WebPublished<Post>
    
    func getPosts(completion: @escaping WebResult<[Post]>)
}

struct APIPostWebService: PostWebService, WebService {
    
    let client: WebClient = .init(urlString: "https://jsonplaceholder.typicode.com")
    
    var requestModifier: Session.RequestModifier? { modify(request:) }
    
    var customHeader: HTTPHeader?
        
    func getPostsPublisher() -> WebPublished<[Post]> {

        struct Params: Encodable {
            let foo: String
        }
        
        return get("/posts", parameters: Params(foo: "bar"))
    }
    
    func getPost(id: Post.ID) -> WebPublished<Post> {
        
        get("/posts/\(id)")
    }
    
    func getPosts(completion: @escaping WebResult<[Post]>) {
        
        get("/posts", completion: completion)
    }
    
    func modify(request: inout URLRequest) throws {
        if let header = customHeader {
            request.headers.add(header)
        }
    }
}

struct FixturesPostWebService: PostWebService {
    
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
