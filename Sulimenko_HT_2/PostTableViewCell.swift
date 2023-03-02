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
    // MARK: - Outlets
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var domain: UILabel!
    @IBOutlet weak var titleName: UILabel!
    @IBOutlet weak var rating: UIButton!
    @IBOutlet weak var commentsCount: UIButton!
    @IBOutlet weak var imagePostView: UIImageView!
    @IBOutlet weak var bookmarkButton: UIButton!
    
    // MARK: - Configuration
    func config(from post: PostData) {
        self.username.text = "@\(post.author)"
        self.time.text = post.time
        self.domain.text = post.domain
        self.titleName.text = post.title
        self.rating.setTitle("\(post.rating)", for: .normal)
        self.commentsCount.setTitle("\(post.numberOfComments)", for: .normal)
        self.imagePostView.sd_setImage(with: URL(string: post.imageURL))
        self.imagePostView.contentMode = .scaleAspectFill
        self.bookmarkButton.setImage(post.saved ? UIImage.init(systemName: "bookmark.fill"): UIImage.init(systemName: "bookmark"), for: .normal)
    }
}
