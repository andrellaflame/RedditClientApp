//
//  ParsedJSON.swift
//  Sulimenko_HT_6
//
//  Created by Andrii Sulimenko on 29.03.2023.
//

import Foundation

class ParsedJSON {
    var comments: [CommentData] = []
    var childrenIDArray: [String] = []
    
    func load(url link: String, onCompletion: @escaping (ParsedJSON) -> Void) {
        let urlSession = URLSession(configuration: .default)
        guard let url = URL(string: link) else { return }
        
        let _ = urlSession.dataTask(with: url) { data, response, error in
            guard let data = data, let dataList = try? JSONDecoder().decode([RedditCommentData].self, from: data) else { return }
            
            self.appendComment(commentsArray: dataList[1].data.children)
            onCompletion(self)
        }.resume()
    }
    
    func loadRelatedComments(onCompletion: @escaping (ParsedJSON) -> Void){
        if (!childrenIDArray.isEmpty) {
            let array = childrenIDArray.prefix(15)
            childrenIDArray = Array(childrenIDArray.dropFirst(15))
            
            var additionalElements = Array(array).reduce("", {x, y in x + "," + y})
            additionalElements.remove(at: additionalElements.startIndex)
            
            guard let parent_id = comments.last?.parent_id else {return}
            
            let urlSession = URLSession(configuration: .default)
            let _ = urlSession.dataTask(with: URL(string: "https://www.reddit.com/api/morechildren.json?depth=0&link_id=\(parent_id)&api_type=json&children=\(additionalElements)")!) { data, response, error in
                guard let data = data, let temp = try? JSONDecoder().decode(PostCommentData.self, from: data) else { return }
                self.appendComment(commentsArray: temp.data.postData.postDetailsArray)
                
                onCompletion(self)
            }.resume()
        }
    }
    
    func appendComment(commentsArray: [CommentChild]){
        for element in commentsArray {
            var temp = CommentData()
            temp.username = element.data.username
            temp.body = element.data.body
            temp.rating = element.data.rating
            temp.permalink = element.data.permalink
            temp.children = element.data.children
            temp.parent_id = element.data.parent_id
            temp.created = {
                let currentTime = Int(NSDate().timeIntervalSince1970)
                guard let timeUTC = element.data.createdUTC else { return "unknown" }
                let difference = currentTime - timeUTC
                switch difference {
                case let temp where temp < 60:
                    return "0h ago"
                case let temp where temp < 3600:
                    return "\(Int(temp/60))m ago";
                case let temp where temp < 86400:
                    return "\(Int(temp/3600))h ago";
                case let temp where temp < 2678400:
                    return "\(Int(temp/86400))d ago";
                case let temp where temp < 31536000:
                    return "\(Int(temp/2678400))mon ago"
                default:
                    return "\(Int(difference/31536000))y ago";
                }
            }()
            
            if (element.kind == "more"){
                guard let childrenID = element.data.children else { return }
                childrenIDArray.append(contentsOf: childrenID)
            }
            
            self.comments.append(temp)
        }
    }
}
