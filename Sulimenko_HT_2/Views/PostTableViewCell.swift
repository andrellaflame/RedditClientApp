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
    @IBOutlet private weak var postView: PostView!
    
    // MARK: - Configuration
    func config(from post: PostData) {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.doubleTapped))
        tap.numberOfTapsRequired = 2
        tap.delaysTouchesBegan = true
        postView.imagePostView.addGestureRecognizer(tap)
        postView.imagePostView.isUserInteractionEnabled = true
        
        self.post = post
        self.postLink = post.link
        
        postView.config(from: post)
        
        NSLayoutConstraint.activate([
            postView.imagePostView.heightAnchor.constraint(equalToConstant: 300)
        ])
        
        postView.shareButton.addTarget(self, action: #selector(tapShareButton), for: .touchUpInside)
        postView.bookmarkButton.addTarget(self, action: #selector(tapSaveButton), for: .touchUpInside)
    }
    
    // MARK: - Actions
    @objc func tapSaveButton(_ sender: Any) {
        self.delegate?.didTapInsideSaveButton(post: &(self.post)!, bookmarkButton: self.postView.bookmarkButton)
    }
    
    @objc func tapShareButton(_ sender: Any) {
        self.delegate?.didTapInsideShareButton(link: self.postLink)
    }
    
    // MARK: - DoubleTapGestureRecognizer
    @objc func doubleTapped() {
        postView.imagePostView.subviews.forEach({ $0.removeFromSuperview() })
        
        let bookmarkSizeBox = postView.imagePostView.bounds.midX / 4
        
        let view = BookmarkView(frame: CGRect(
            x: postView.imagePostView.bounds.midX - bookmarkSizeBox / 2,
            y: postView.imagePostView.bounds.midY - bookmarkSizeBox / 3 * 2,
            width: bookmarkSizeBox,
            height: bookmarkSizeBox))
        view.isHidden = true
        
        postView.imagePostView.addSubview(view)

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
                    animations: { view.isHidden = true },
                    completion: {_ in
                        if !(self.post?.saved ?? false) {
                            self.tapSaveButton(self.postView.bookmarkButton!)
                        }
                    })
            })
    }
}
