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
    
    init(id: Int, userId: Int, title: String, body: String) {
        self.id = id
        self.userId = userId
        self.title = title
        self.body = body
    }
}
