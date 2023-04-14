//
//  CommentDTO.swift
//  Sulimenko_HT_6
//
//  Created by Andrii Sulimenko on 29.03.2023.
//

import Foundation

struct RedditCommentData: Codable {
    let data: RedditCommentDetails
    
    enum CodingKeys: String, CodingKey {
        case data
    }
}

struct RedditCommentDetails: Codable {
    let children: [CommentChild]
    
    enum CodingKeys: String, CodingKey {
        case children
    }
}

struct CommentChild: Codable {
    let kind: String
    let data: Comment
    
    enum CodingKeys: String, CodingKey {
        case kind, data
    }
}

struct Comment: Codable {
    var username: String?
    var createdUTC: Int?
    var body: String?
    var rating: Int?
    var permalink: String?
    var children: [String]?
    var parent_id: String?
    
    enum CodingKeys: String, CodingKey {
        case body, permalink, children, parent_id
        case username = "author"
        case rating = "score"
        case createdUTC = "created"
    }
}

// MARK: Retrieve more comments from children struct

struct PostCommentData: Codable {
    let data: PostDataJson
    
    enum CodingKeys: String, CodingKey {
        case data = "json"
    }
}

struct PostDataJson: Codable {
    let postData: PostDataDetails
    
    enum CodingKeys: String, CodingKey {
        case postData = "data"
    }
}

struct PostDataDetails: Codable {
    let postDetailsArray: [CommentChild]
    
    enum CodingKeys: String, CodingKey {
        case postDetailsArray = "things"
    }
}
