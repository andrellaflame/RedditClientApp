//
//  PostTableViewCell.swift
//  Sulimenko_HT_2
//
//  Created by Andrii Sulimenko on 01.03.2023.
//

import Foundation
import UIKit
import SDWebImage

// MARK: - Protocols
protocol PostTableViewCellDelegate: AnyObject {
    func didTapInsideShareButton(link: String)
    func didTapInsideSaveButton(post: inout PostData, bookmarkButton: UIButton)
}


class PostTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    weak var delegate: PostTableViewCellDelegate?
    private var postLink = String()
    private var post: PostData?
    private var bookmarkAnimationIcon: UIView?
    
    // MARK: - IBOutlets
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var domain: UILabel!
    @IBOutlet weak var titleName: UILabel!
    @IBOutlet weak var rating: UIButton!
    @IBOutlet weak var commentsCount: UIButton!
    @IBOutlet weak var imagePostView: UIImageView!
    @IBOutlet weak var bookmarkButton: UIButton!
    
    // MARK: - IBActions
    @IBAction func tapShareButton(_ sender: Any) {
        self.delegate?.didTapInsideShareButton(link: self.postLink)
    }
    
    @IBAction func tapSaveButton(_ sender: Any) {
        self.delegate?.didTapInsideSaveButton(post: &(self.post)!, bookmarkButton: self.bookmarkButton)
    }
    
    // MARK: - Configuration
    func config(from post: PostData) {
    
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.doubleTapped))
        tap.numberOfTapsRequired = 2
        tap.delaysTouchesBegan = true
        self.imagePostView.addGestureRecognizer(tap)
        self.imagePostView.isUserInteractionEnabled = true
        
        self.post = post
        self.postLink = post.link
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
    
    // MARK: - DoubleTapGestureRecognizer
    @objc func doubleTapped() {
        self.imagePostView.subviews.forEach({ $0.removeFromSuperview() })
        
        let bookmarkSizeBox = self.imagePostView.bounds.midX / 4
        
        let view = BookmarkView(frame: CGRect(
            x: self.imagePostView.bounds.midX - bookmarkSizeBox / 2,
            y: self.imagePostView.bounds.midY - bookmarkSizeBox / 3 * 2,
            width: bookmarkSizeBox,
            height: bookmarkSizeBox))
        view.isHidden = true
        
        self.imagePostView.addSubview(view)

        UIView.transition(
            with: self,
            duration: 0.2,
            options: .transitionCrossDissolve,
            animations: { view.isHidden = false },
            completion: {_ in
                UIView.transition(
                    with: self,
                    duration: 0.4,
                    options: .transitionCrossDissolve,
                    animations: { view.isHidden = true},
                    completion: {_ in
                        if !(self.post?.saved ?? false) {
                            self.tapSaveButton(self.bookmarkButton!)
                        }
                    })
            })
    }
}
