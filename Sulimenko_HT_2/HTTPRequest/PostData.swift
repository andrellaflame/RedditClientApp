//
//  PostData.swift
//  Sulimenko_HT_2
//
//  Created by Andrii Sulimenko on 01.03.2023.
//

import Foundation

struct PostData {
    let saved: Bool
    let title: String
    let rating: Int
    let domain: String
    let author: String
    let numberOfComments: Int
    let imageURL: String
    let time: String

    init(from data: Post) {
        self.saved = data.saved
        self.title = data.title
        self.rating = (data.downs + data.ups)
        self.domain = data.domain
        self.author = data.author
        self.numberOfComments = data.numberOfComments
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
}
