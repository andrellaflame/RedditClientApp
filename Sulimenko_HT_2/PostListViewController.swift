//
//  PostListViewController.swift
//  Sulimenko_HT_2
//
//  Created by Andrii Sulimenko on 01.03.2023.
//

import Foundation
import UIKit

class PostListViewController: UIViewController {
    
    // MARK: - Const
    enum Const {
        static let cellReuseIdentifier = "reusable_post_cell"
        static let openPostPageSegue = "open_post_page"
        static let numberOfPostsOnPage = 15
        static let requestSubreddit = "ios"
        static var afterParameter: String? = ""
        static let url = "https://www.reddit.com"
        static let fileName = "PostData.json"
    }
    
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var showSavedPostsButton: UIBarButtonItem!
    @IBOutlet weak var navigationBar: UINavigationItem!
    @IBOutlet weak var searchTextField: UITextField!
    
    // MARK: - Properties & data
    private let networkService = NetworkService()
    private var lastSelectedPost: PostData?
    private var isShowingSavedPosts = false
    
    // MARK: - IBActions
    @IBAction func tapShowSavedPostsButton(_ sender: Any) {
        self.isShowingSavedPosts.toggle()
        print(self.isShowingSavedPosts ? "Showing saved posts": "Showing all posts")
        if self.isShowingSavedPosts {
            PostDataManager.shared.displayedPosts = PostDataManager.shared.savedPosts
            self.showSavedPostsButton.image = UIImage(systemName: "bookmark.circle.fill")
            self.showSavedPostsButton.tintColor = .systemOrange
            
            self.searchTextField.isHidden = false
        }
        else {
            PostDataManager.shared.displayedPosts = PostDataManager.shared.allPosts
            self.showSavedPostsButton.image = UIImage(systemName: "bookmark.circle")
            self.showSavedPostsButton.tintColor = .black
            
            self.searchTextField.isHidden = true
        }
        
        self.tableView.reloadData()
    }
    
    // MARK: - Lyfecycle
    override func viewDidLoad() {
        // Do any additional setup after loading the view.
        PostDataManager.shared.readJSON()
        self.tableView.showsVerticalScrollIndicator = true
        
        self.networkService.fetchData(
            subreddit: Const.requestSubreddit,
            httpHeaders: ["limit":"\(Const.numberOfPostsOnPage)"]
        ) {
            listOfPosts in
            DispatchQueue.main.async {                
                PostDataManager.shared.displayedPosts = listOfPosts.map { post in
                    var postTemp = post
                    for savedPost in PostDataManager.shared.savedPosts{
                        if (savedPost.id == post.id) {
                            postTemp.saved = true
                        }
                    }
                    return postTemp
                }
                PostDataManager.shared.allPosts.append(contentsOf: PostDataManager.shared.displayedPosts)
                self.tableView.reloadData()
            }
        }
        
        super.viewDidLoad()
        
        self.navigationItem.title = "r/\(Const.requestSubreddit)"
        self.navigationItem.backButtonTitle = "Back"
        self.searchTextField.isHidden = true
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.searchTextField.delegate = self
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case Const.openPostPageSegue:
            let nextViewController = segue.destination as! PostDetailsViewController
            
            DispatchQueue.main.async {
                if let selectedPost = self.lastSelectedPost {
                    nextViewController.configure(with: selectedPost)
                    nextViewController.referenceTable = self.tableView
                }
            }
        default: break
        }
    }
    
    private func createEndPageMessage() -> UIView {
        let footer = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 32))
        let image = UIImageView(image: UIImage(named: "25x25RedditLogo.png")!)
        image.center = footer.center
        footer.addSubview(image)
        footer.backgroundColor = .systemOrange
        return footer
    }
}

// MARK: - UITableViewDataSource
extension PostListViewController: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return PostDataManager.shared.displayedPosts.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: Const.cellReuseIdentifier,
            for: indexPath
        ) as! PostTableViewCell
        
        cell.config(from: PostDataManager.shared.displayedPosts[indexPath.row])
        cell.delegate = self
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension PostListViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        self.lastSelectedPost = PostDataManager.shared.displayedPosts[indexPath.row]
        self.performSegue(withIdentifier: Const.openPostPageSegue, sender: nil)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if !self.isShowingSavedPosts {

            tableView.tableHeaderView = nil
            
            let offsetY = scrollView.contentOffset.y
            let height = scrollView.contentSize.height

            guard let after = Const.afterParameter else {
                tableView.tableFooterView = createEndPageMessage()
                return
            }

            if offsetY > height - scrollView.frame.height {
                self.networkService.fetchData(
                    subreddit: "ios",
                    httpHeaders: ["limit":"\(Const.numberOfPostsOnPage)",
                                  "after":after]
                ) {
                    listOfPosts in
                    DispatchQueue.main.async {
                        let modified = listOfPosts.map({ element -> PostData in
                            var copy = element
                            for postElement in PostDataManager.shared.savedPosts {
                                if (postElement.id == element.id) {
                                    copy.saved = true
                                }
                            }
                            return copy
                        })
                        
                        PostDataManager.shared.displayedPosts.append(contentsOf: modified)
                        PostDataManager.shared.allPosts.append(contentsOf: modified)
                        self.tableView.reloadData()
                    }
                }
            }
        }
        else {
            tableView.tableFooterView = createEndPageMessage()
        }
    }
}

// MARK: - PostTableViewCellDelegate
extension PostListViewController: PostTableViewCellDelegate {
    func didTapInsideSaveButton(post: inout PostData, bookmarkButton: UIButton) {
        AppService.didTapInsideSaveButton(post: &post, bookmarkButton: bookmarkButton)
        self.tableView.reloadData()
    }
    
    func didTapInsideShareButton(link: String) {
        AppService.didTapInsideShareButton(link: link, vc: self)
    }
}

// MARK: - UITextFieldDelegate
extension PostListViewController: UITextFieldDelegate {
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        let searchText = (textField.text ?? "") + string

        PostDataManager.shared.displayedPosts =
        PostDataManager.shared.savedPosts.filter({
            $0.title.lowercased().contains(searchText.lowercased())
        })

        tableView.reloadData()
        return true
    }
}
