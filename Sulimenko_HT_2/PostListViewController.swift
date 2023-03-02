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
    struct Const {
        static let cellReuseIdentifier = "reusable_post_cell"
        static let openPostPageSegue = "open_post_page"
        static let numberOfPostsOnPage = 15
        static let requestSubreddit = "ios"
        static var afterParameter: String? = ""
    }
    
    // MARK: - Properties & data
    @IBOutlet weak var tableView: UITableView!
    private let networkService = NetworkService()
    private var list = [PostData]()
    private var lastSelectedPost: PostData?
    
    
    // MARK: - Lyfecycle
    override func viewDidLoad() {
        // Do any additional setup after loading the view.
        self.tableView.showsVerticalScrollIndicator = true
        
        self.networkService.fetchData(
            subreddit: Const.requestSubreddit,
            httpHeaders: ["limit":"\(Const.numberOfPostsOnPage)"]
        ) {
            listOfPosts in
            DispatchQueue.main.async {
                self.list = listOfPosts
                self.tableView.reloadData()
            }
        }
        
        super.viewDidLoad()
        self.navigationItem.title = "r/\(Const.requestSubreddit)"
        self.navigationItem.backButtonTitle = "Back"
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case Const.openPostPageSegue:
            let nextViewController = segue.destination as! PostDetailsViewController
            
            DispatchQueue.main.async {
                if let selectedPost = self.lastSelectedPost {
                    nextViewController.configure(with: selectedPost)
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
        return list.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: Const.cellReuseIdentifier,
            for: indexPath
        ) as! PostTableViewCell
        
        cell.config(from: self.list[indexPath.row])
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension PostListViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        self.lastSelectedPost = self.list[indexPath.row]
        self.performSegue(withIdentifier: Const.openPostPageSegue, sender: nil)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
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
                    self.list.append(contentsOf: listOfPosts)
                    self.tableView.reloadData()
                }
            }
        }
    }
}
