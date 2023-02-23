//
//  ViewController.swift
//  Sulimenko_HT_2
//
//  Created by Andrii Sulimenko on 23.02.2023.
//

import UIKit
import SDWebImage

class PostViewController: UIViewController {
    
    private let networkService = NetworkService()
    
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var domain: UILabel!
    @IBOutlet weak var titleName: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var commentsCount: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var bookmarkButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.networkService.fetchData(subreddit: "ios", httpHeaders: ["limit":"1"]) {
            post in
            
            DispatchQueue.main.async {
                self.username.text = post.author
                self.time.text = "\(post.createdUtcTime)"
                self.domain.text = post.domain
                self.titleName.text = post.title
                self.rating.text = "\(post.ups + post.downs)"
                self.commentsCount.text = "\(post.numberOfComments)"
                self.imageView.sd_setImage(with: URL(string: post.preview?.images.first?.source.url.replacing("&amp;", with: "&") ?? ""))
                self.bookmarkButton.setImage(Bool.random() ? UIImage.init(systemName: "bookmark"): UIImage.init(systemName: "bookmark.fill"), for: .normal)
            }
        }
    }
    
    @IBAction func tapShareButton(_ sender: Any) {
    }
    @IBAction func tapBookmarkButton(_ sender: Any) {
    }
    @IBAction func tapCommentButton(_ sender: Any) {
    }
}

