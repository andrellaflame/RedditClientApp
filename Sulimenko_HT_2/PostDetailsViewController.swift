//
//  ViewController.swift
//  Sulimenko_HT_2
//
//  Created by Andrii Sulimenko on 23.02.2023.
//

import UIKit
import SDWebImage

class PostDetailsViewController: UIViewController {
    
    // MARK: - Properties
    var post: PostData?
        
    // MARK: - IBOutlets
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var domain: UILabel!
    @IBOutlet weak var titleName: UILabel!
    @IBOutlet weak var rating: UIButton!
    @IBOutlet weak var commentsCount: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var bookmarkButton: UIButton!
        
    // MARK: - Configuration
    func configure(with post: PostData) {
        self.post = post
        self.username.text = "@\(post.author)"
        self.time.text = post.time
        self.domain.text = post.domain
        self.titleName.text = post.title
        self.rating.setTitle("\(post.rating)", for: .normal)
        self.commentsCount.setTitle("\(post.numberOfComments)", for: .normal)
        self.imageView.sd_setImage(with: URL(string: post.imageURL))
        self.bookmarkButton.setImage(post.saved ? UIImage.init(systemName: "bookmark.fill"): UIImage.init(systemName: "bookmark"), for: .normal)
        
        self.navigationItem.title = "r/\(post.author)"
    }
    
    // MARK: - IBActions
    @IBAction func tapShareButton(_ sender: Any) {
        if let urlString = self.post?.link {
            AppService.didTapInsideShareButton(link: urlString, vc: self)
        }
    }
}
