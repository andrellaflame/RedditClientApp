//
//  AppService.swift
//  Sulimenko_HT_2
//
//  Created by Andrii Sulimenko on 08.03.2023.
//

import Foundation
import UIKit

struct AppService {
    static func didTapInsideShareButton(link: String, vc: UIViewController) {
        let items: [Any] = ["Check this out \(URL(string: "\(PostListViewController.Const.url)\(link)")!)"]
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)

        vc.present(ac, animated: true, completion: nil)
    }
    
    static func didTapInsideSaveButton(post: inout PostData, bookmarkButton: UIButton) {
        post.saved.toggle()
        if post.saved {
            bookmarkButton.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
            AppService.savePost(post: post)
        } else {
            bookmarkButton.setImage(UIImage(systemName: "bookmark"), for: .normal)
            AppService.deletePost(post: post)
        }
    }
    
    private static func savePost(post: PostData) {
        if !PostDataManager.shared.savedPosts.contains(post) {
            PostDataManager.shared.savedPosts.append(post)
            
            PostDataManager.shared.allPosts = PostDataManager.shared.allPosts.map({ element in
                var copy = element
                if (copy.id == post.id) {
                    copy.saved = true
                }
                return copy
            })
            
            PostDataManager.shared.displayedPosts = PostDataManager.shared.displayedPosts.map({ element in
                var copy = element
                if (copy.id == post.id) {
                    copy.saved = true
                }
                return copy
            })
        }
    }
    
    private static func deletePost(post: PostData) {
        
        for (index, value) in PostDataManager.shared.savedPosts.enumerated() {
            if (value.id == post.id) {
                PostDataManager.shared.savedPosts.remove(at: index)
            }
        }
     
        PostDataManager.shared.allPosts = PostDataManager.shared.allPosts.map({ element in
            var copy = element
            if (copy.id == post.id) {
                copy.saved = false
            }
            return copy
        })

        PostDataManager.shared.displayedPosts = PostDataManager.shared.displayedPosts.map({ element in
            var copy = element
            if (copy.id == post.id) {
                copy.saved = false
            }
            return copy
        })
    }
}
