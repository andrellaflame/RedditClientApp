//
//  ViewController.swift
//  Sulimenko_HT_2
//
//  Created by Andrii Sulimenko on 23.02.2023.
//

import UIKit
import SwiftUI
import SDWebImage

class PostDetailsViewController: UIViewController {
    
    // MARK: - Properties
    var post: PostData?
    weak var referenceTable: UITableView?
    private var bookmarkAnimationIcon: UIView?
        
    // MARK: - IBOutlets
    @IBOutlet private weak var postView: PostView!
    @IBOutlet private weak var commentsView: UIView!
    
    
    // MARK: - Constraints
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSLayoutConstraint.activate([
            postView.heightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.5),
            commentsView.heightAnchor.constraint(equalTo: self.postView.heightAnchor),
        ])
    }
    
    // MARK: - Configuration
    func config(from post: PostData) {
        DispatchQueue.main.async { [self] in
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.doubleTapped))
            tap.numberOfTapsRequired = 2
            
            postView.imagePostView.gestureRecognizers?.forEach{ postView.imagePostView.removeGestureRecognizer($0) }
            postView.imagePostView.addGestureRecognizer(tap)
            postView.imagePostView.isUserInteractionEnabled = true
            
            self.post = post
            self.navigationItem.title = "r/\(post.author)"
            
            postView.config(from: post)
            postView.imagePostView.contentMode = .scaleAspectFit
            postView.shareButton.addTarget(self, action: #selector(tapShareButton), for: .touchUpInside)
            postView.bookmarkButton.addTarget(self, action: #selector(tapSaveButton), for: .touchUpInside)
            
            loadComments(from: post)
        }
    }
    
    func loadComments(from post: PostData) {
        let swiftUIViewController: UIViewController = UIHostingController(rootView: CommentList()
            .environmentObject(
                CommentStorage(subreddit: "ios", postID: post.id)
            ))
        
        let swiftUIView: UIView = swiftUIViewController.view
        self.commentsView.addSubview(swiftUIView)
        
        swiftUIView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            swiftUIView.topAnchor.constraint(equalTo: self.commentsView.topAnchor),
            swiftUIView.trailingAnchor.constraint(equalTo: self.commentsView.trailingAnchor),
            swiftUIView.bottomAnchor.constraint(equalTo: self.commentsView.bottomAnchor),
            swiftUIView.leadingAnchor.constraint(equalTo: self.commentsView.leadingAnchor)
        ])
        
        swiftUIViewController.didMove(toParent: self)
    }
    
    // MARK: - Actions
    @objc func tapShareButton(_ sender: Any) {
        if let urlString = self.post?.link {
            AppService.didTapInsideShareButton(link: urlString, vc: self)
        }
    }
    
    @objc func tapSaveButton(_ sender: Any) {
        AppService.didTapInsideSaveButton(post: &(self.post)!, bookmarkButton: self.postView.bookmarkButton)
        self.referenceTable?.reloadData()
    }
    
    // MARK: - DoubleTapGestureRecognizer
    @objc func doubleTapped() {
        let bookmarkSizeBox = postView.imagePostView.bounds.midX / 4
        self.bookmarkAnimationIcon = BookmarkView(frame: CGRect(
            x: postView.imagePostView.bounds.midX - bookmarkSizeBox / 2,
            y: postView.imagePostView.bounds.midY - bookmarkSizeBox / 3 * 2,
            width: bookmarkSizeBox,
            height: bookmarkSizeBox))
       
        postView.imagePostView.addSubview(self.bookmarkAnimationIcon!)

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
            self.tapSaveButton(self.postView.bookmarkButton!)
        }
    }
}
