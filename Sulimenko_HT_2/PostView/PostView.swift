//
//  PostView.swift
//  Sulimenko_HT_2
//
//  Created by Andrii Sulimenko on 13.04.2023.
//

import UIKit

class PostView: UIView {
    let kCONTENT_XIB_NAME = "PostView"
    
    // MARK: - IBOutlets
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var username: UILabel!
    @IBOutlet private weak var time: UILabel!
    @IBOutlet private weak var domain: UILabel!
    @IBOutlet private weak var titleName: UILabel!
    @IBOutlet private weak var rating: UIButton!
    @IBOutlet private weak var commentsCount: UIButton!
    @IBOutlet private weak var imagePostView: UIImageView!
    @IBOutlet private weak var bookmarkButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed(kCONTENT_XIB_NAME, owner: self, options: nil)
        contentView.fixInView(self)
    }
    
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

extension UIView {
    func fixInView(_ container: UIView!) -> Void {
        self.translatesAutoresizingMaskIntoConstraints = false;
        self.frame = container.frame;
        container.addSubview(self);
        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
    }
}
