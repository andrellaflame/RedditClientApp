//
//  NetworkService.swift
//  Sulimenko_HT_2
//
//  Created by Andrii Sulimenko on 23.02.2023.
//

import Foundation

class NetworkService {
    func fetchData(subreddit: String, httpHeaders: [String: String], onComplete: @escaping ([PostData]) -> Void) {
        var headers = ""
        httpHeaders.forEach {
            headers.append($0.key + "=" + $0.value + "&")
        }
        let link = "https://www.reddit.com/r/\(subreddit)/top.json?\(headers)"
        guard let url = URL(string: link) else { return }
        
        URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, let redditData = try? JSONDecoder().decode(RedditData.self, from: data) else { return }
            PostListViewController.Const.afterParameter = redditData.data.after
            onComplete(redditData.data.children.map({ return PostData(from: $0.data) }))
        }.resume()
    }
}
