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
    weak var referenceTable: UITableView?
    private var bookmarkAnimationIcon: UIView?
        
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
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        tap.numberOfTapsRequired = 2
        self.imageView.gestureRecognizers?.forEach{ self.imageView.removeGestureRecognizer($0) }
        self.imageView.addGestureRecognizer(tap)
        self.imageView.isUserInteractionEnabled = true
    }
    
    
    // MARK: - DoubleTapGestureRecognizer
    @objc func doubleTapped() {
        self.bookmarkAnimationIcon = BookmarkView(frame: CGRect(
            x: self.view.bounds.midX - self.view.bounds.midX / 2,
            y: self.view.bounds.midY - self.view.bounds.midY / 3 * 2,
            width: self.view.bounds.midX,
            height: self.view.bounds.midX))
        
        self.imageView.addSubview(self.bookmarkAnimationIcon!)

        DispatchQueue.main.asyncAfter(deadline: .now()) {
            UIView.transition(
                with: self.view,
                duration: 0.2,
                options: .transitionCrossDissolve,
                animations: { self.bookmarkAnimationIcon?.isHidden = false },
                completion: {_ in
                    UIView.transition(
                        with: self.view,
                        duration: 0.4,
                        options: .transitionCrossDissolve) {
                        self.bookmarkAnimationIcon?.isHidden = true
                    }
            })
        }
        
        if !(self.post?.saved ?? false) {
            self.tapSaveButton(self.bookmarkButton!)
        }
    }
    
    // MARK: - IBActions
    @IBAction func tapShareButton(_ sender: Any) {
        if let urlString = self.post?.link {
            AppService.didTapInsideShareButton(link: urlString, vc: self)
        }
    }
    
    @IBAction func tapSaveButton(_ sender: Any) {
        AppService.didTapInsideSaveButton(post: &(self.post)!, bookmarkButton: self.bookmarkButton)
        self.referenceTable?.reloadData()
    }
}
