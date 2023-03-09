//
//  PostData.swift
//  Sulimenko_HT_2
//
//  Created by Andrii Sulimenko on 01.03.2023.
//

import Foundation

struct PostData: Codable, Equatable {
    var saved: Bool
    let title: String
    let rating: Int
    let domain: String
    let author: String
    let numberOfComments: Int
    let imageURL: String
    let time: String
    let link: String
    let id: String

    init(from data: Post) {
        self.saved = data.saved
        self.title = data.title
        self.rating = (data.downs + data.ups)
        self.domain = data.domain
        self.author = data.author
        self.numberOfComments = data.numberOfComments
        self.link = data.link
        self.id = data.id
        self.imageURL = data.preview?.images.first?.source.url.replacing("&amp;", with: "&") ?? ""
        self.time = {
            let currentTime = Int(NSDate().timeIntervalSince1970)
            let difference = currentTime - data.createdUtcTime
            switch difference {
            case let temp where temp < 60:
                return "0h ago"
            case let temp where temp < 3600:
                return "\(Int(temp/60))m ago";
            case let temp where temp < 86400:
                return "\(Int(temp/3600))h ago";
            case let temp where temp < 2678400:
                return "\(Int(temp/86400))d ago";
            case let temp where temp < 31536000:
                return "\(Int(temp/2678400))mon ago"
            default:
                return "\(Int(difference/31536000))y ago";
            }
        }()
    }
    
    enum CodingKeys: String, CodingKey {
        case saved, title, rating, domain, author, numberOfComments, imageURL, time, link, id
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(author, forKey: .author)
        try container.encode(domain, forKey: .domain)
        try container.encode(time, forKey: .time)
        try container.encode(title, forKey: .title)
        try container.encode(imageURL, forKey: .imageURL)
        try container.encode(numberOfComments, forKey: .numberOfComments)
        try container.encode(rating, forKey: .rating)
        try container.encode(saved, forKey: .saved)
        try container.encode(link, forKey: .link)
        try container.encode(id, forKey: .id)
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.author = try values.decode(String.self, forKey: .author)
        self.domain = try values.decode(String.self, forKey: .domain)
        self.time = try values.decode(String.self, forKey: .time)
        self.title = try values.decode(String.self, forKey: .title)
        self.imageURL = try values.decode(String.self, forKey: .imageURL)
        self.numberOfComments = try values.decode(Int.self, forKey: .numberOfComments)
        self.rating = try values.decode(Int.self, forKey: .rating)
        self.saved = try values.decode(Bool.self, forKey: .saved)
        self.link = try values.decode(String.self, forKey: .link)
        self.id = try values.decode(String.self, forKey: .id)
    }
}
