//
//  PostTableViewCell.swift
//  Sulimenko_HT_2
//
//  Created by Andrii Sulimenko on 01.03.2023.
//

import Foundation
import UIKit
import SDWebImage

class PostTableViewCell: UITableViewCell {
    // MARK: - Outlet
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var domain: UILabel!
    @IBOutlet weak var titleName: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var commentsCount: UILabel!
    @IBOutlet weak var imagePostView: UIImageView!
    @IBOutlet weak var bookmarkButton: UIButton!
    
    // MARK: - Config
    func config(from post: PostData) {
        self.username.text = post.author
        
        self.time.text = post.time
        self.domain.text = post.domain
        self.titleName.text = post.title
        self.rating.text = "\(post.rating)"
        self.commentsCount.text = "\(post.numberOfComments)"
        self.imagePostView.sd_setImage(with: URL(string: post.imageURL))
//        self.imagePostView.frame.size.height = 200.0
//        self.imagePostView.contentMode = .scaleAspectFill
        
        self.bookmarkButton.setImage(Bool.random() ? UIImage.init(systemName: "bookmark"): UIImage.init(systemName: "bookmark.fill"), for: .normal)
    }
}
