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
                
                self.time.text = {
                    let currentTime = Int(NSDate().timeIntervalSince1970)
                    let difference = currentTime - post.createdUtcTime
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
                
                self.domain.text = post.domain
                self.titleName.text = post.title
                self.rating.text = "\(post.ups + post.downs)"
                self.commentsCount.text = "\(post.numberOfComments)"
                
                self.imageView.sd_setImage(with: URL(string: post.preview?.images.first?.source.url.replacing("&amp;", with: "&") ?? ""))
                
                self.imageView.frame.size.height = 200.0
                self.imageView.contentMode = .scaleAspectFill
                
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

