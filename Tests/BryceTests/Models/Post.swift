//
//  Post.swift
//  Bryce_Tests
//
//  Created by Ephraim Russo on 1/26/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation

final class Post: Codable {
    
    let id: Int
    let userId: Int
    let title: String
    let body: String
    
    init(id: Int = .random(in: 0...1000), userId: Int = .random(in: 0...1000), title: String, body: String) {
        self.id = id
        self.userId = userId
        self.title = title
        self.body = body
    }
}

extension Post {
    
    static var fixtures: [Post] = [
        .init(title: "How to impress others", body: "Tap to learn more about impressing others"),
        .init(title: "How to be the best", body: "Tap to learn more about being the best"),
        .init(title: "How to climb a mountain", body: "Tap to learn more about climbing mountains")
    ]
}
