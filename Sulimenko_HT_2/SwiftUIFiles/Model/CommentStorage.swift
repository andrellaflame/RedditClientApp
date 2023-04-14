//
//  CommentStorage.swift
//  Sulimenko_HT_6
//
//  Created by Andrii Sulimenko on 29.03.2023.
//

import Foundation
import SwiftUI

final class CommentStorage: ObservableObject {
    @Published var comments: [CommentData] = []
    let storage = ParsedJSON()
    let subreddit: String
    let postID: String
    
    init(subreddit: String, postID: String) {
        
        self.subreddit = subreddit
        self.postID = postID
        
        storage.load(url: "https://www.reddit.com/r/\(subreddit)/comments/\(postID)/.json?limit=15") { [weak self] arrayOfComments in
            DispatchQueue.main.async {
                self?.comments = arrayOfComments.comments
            }
        }
    }
    
    func loadMoreComments() {
        storage.loadRelatedComments() { [weak self] arrayOfRelatedComments in
            DispatchQueue.main.async {
                self?.comments = arrayOfRelatedComments.comments
            }
        }
    }
}


