//
//  PostListViewController.swift
//  Sulimenko_HT_2
//
//  Created by Andrii Sulimenko on 01.03.2023.
//

import Foundation
import UIKit

class PostListViewController: UIViewController, UITableViewDelegate {
    
    // MARK: - Const
    struct Const {
        static let cellReuseIdentifier = "reusable_post_cell"
    }
    
    // MARK: - Properties & data
    @IBOutlet weak var tableView: UITableView!
    private let networkService = NetworkService()
    private var list = [Post]()
    private var currentPost = PostData()
    
    
    // MARK: - Lyfecycle
    
    override func viewDidLoad() {
//        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tableView.showsVerticalScrollIndicator = true
        
        self.networkService.fetchData(subreddit: "ios", httpHeaders: ["limit":"1"]) {
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
    
}

// MARK: - UITableViewDataSource
extension PostListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: Const.cellReuseIdentifier,
            for: indexPath
        ) as! PostTableViewCell
        
        return cell
    }
}
