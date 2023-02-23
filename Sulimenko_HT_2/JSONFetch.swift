//
//  JSONFetch.swift
//  Sulimenko_HT_2
//
//  Created by Andrii Sulimenko on 23.02.2023.
//

import Foundation

struct RedditData: Decodable {
    let data: Details
    
    enum CodingKeys: String, CodingKey {
        case data
    }
}

struct Details: Decodable {
    let after: String?
    let children: [Child]
    
    enum CodingKeys: String, CodingKey {
        case children
        case after
    }
}

struct Child: Decodable {
    let data: Post
    
    enum CodingKeys: String, CodingKey{
        case data
    }
}

struct Post: Decodable{
    let saved: Bool
    let title: String
    let downs: Int
    let ups: Int
    let domain: String
    let author: String
    let numberOfComments: Int
    let preview: Preview?
    let createdUtcTime: Int
    
    enum CodingKeys: String, CodingKey {
        case saved, title, downs, ups, domain, preview
        case author = "author"
        case numberOfComments = "num_comments"
        case createdUtcTime = "created_utc"
    }
}

struct Preview: Decodable {
    let images: [Image]
    
    enum CodingKeys: String, CodingKey{
        case images
    }
}

struct Image: Decodable {
    let source: Source
    enum CodingKeys:String, CodingKey{
        case source
    }
}

struct Source: Decodable {
    let url: String
    
    enum CodingKeys:String, CodingKey {
        case url
    }
}

