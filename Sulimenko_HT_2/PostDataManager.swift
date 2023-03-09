//
//  PostDataManager.swift
//  Sulimenko_HT_2
//
//  Created by Andrii Sulimenko on 08.03.2023.
//

import Foundation
import UIKit

class PostDataManager {
    var allPosts = [PostData]()
    var savedPosts = [PostData]()
    var displayedPosts = [PostData]()
    
    var filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(PostListViewController.Const.fileName)
    
    static let shared = PostDataManager()
    
    // Add read and write from/to .json
    func writeJSON() {
        print("Trying to write: \(self.filePath)")
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted

        if let data = try? encoder.encode(self.savedPosts) {
            do {
                try String(data: data, encoding: .utf8)?.write(to: self.filePath, atomically: true, encoding: .utf8)
            } catch {
                print("Writing JSON file failed: \(error.localizedDescription)")
            }
        }
    }
    
    func readJSON() {
        print("Trying to read: \(self.filePath)")
        do{
            let data = try Foundation.Data(contentsOf: self.filePath)
            self.savedPosts = try JSONDecoder().decode([PostData].self, from: data)
        }
        catch {
            print("Failed to read JSON data: \(error.localizedDescription)")
        }
    }
}
