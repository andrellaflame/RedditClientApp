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
        static let numberOfPostsOnPage = 10
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
        
        self.networkService.fetchData(subreddit: "ios", httpHeaders: ["limit":"\(Const.numberOfPostsOnPage)"]) {
            listOfPosts in
            DispatchQueue.main.async {
                self.list = listOfPosts
                self.tableView.reloadData()
            }
        }
        
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case Const.openPostPageSegue:
            let nextViewController = segue.destination as! PostViewController
            
            DispatchQueue.main.async {
                if let selectedPost = self.lastSelectedPost {
                    nextViewController.configure(with: selectedPost)
                }
            }
            
            
        default: break
        }
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
}
