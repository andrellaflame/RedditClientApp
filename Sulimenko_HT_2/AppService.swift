//
//  AppService.swift
//  Sulimenko_HT_2
//
//  Created by Andrii Sulimenko on 08.03.2023.
//

import Foundation
import UIKit

struct AppService {
    static func didTapInsideShareButton(link: String, vc: UIViewController) {
        let items: [Any] = ["Check this out \(URL(string: "\(PostListViewController.Const.url)\(link)")!)"]
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)

        vc.present(ac, animated: true, completion: nil)
    }
    
    static func didTapInsideSaveButtom() {
        
    }
}
