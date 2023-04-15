//
//  CommentData.swift
//  Sulimenko_HT_6
//
//  Created by Andrii Sulimenko on 30.03.2023.
//

import Foundation

struct CommentData: Identifiable {
    var id = UUID()
    
    var username: String?
    var created: String?
    var body: String?
    var rating: Int?
    var permalink: String?
    var children: [String]?
    var parent_id: String?
}

extension CommentData {
    static let testComment = CommentData(
        username: "Jake Hart",
        created: "12h ago",
        body: "I like cooking because it makes me happy. Indeed I like doing lots of stuff. For example, I just enjoy reading long texts like this one: 'Swift is a powerful and intuitive programming language for iOS, iPadOS, macOS, tvOS, and watchOS. Writing Swift code is interactive and fun, the syntax is concise yet expressive, and Swift includes modern features developers love. Swift code is safe by design and produces software that runs lightning-fast.' I like cooking because it makes me happy. Indeed I like doing lots of stuff. For example, I just enjoy reading long texts like this one: 'Swift is a powerful and intuitive programming language for iOS, iPadOS, macOS, tvOS, and watchOS. Writing Swift code is interactive and fun, the syntax is concise yet expressive, and Swift includes modern features developers love. Swift code is safe by design and produces software that runs lightning-fast.' I like cooking because it makes me happy. Indeed I like doing lots of stuff. For example, I just enjoy reading long texts like this one: 'Swift is a powerful and intuitive programming language for iOS, iPadOS, macOS, tvOS, and watchOS. Writing Swift code is interactive and fun, the syntax is concise yet expressive, and Swift includes modern features developers love. Swift code is safe by design and produces software that runs lightning-fast.' I like cooking because it makes me happy. Indeed I like doing lots of stuff. For example, I just enjoy reading long texts like this one: 'Swift is a powerful and intuitive programming language for iOS, iPadOS, macOS, tvOS, and watchOS. Writing Swift code is interactive and fun, the syntax is concise yet expressive, and Swift includes modern features developers love. Swift code is safe by design and produces software that runs lightning-fast.' I like cooking because it makes me happy. Indeed I like doing lots of stuff. For example, I just enjoy reading long texts like this one: 'Swift is a powerful and intuitive programming language for iOS, iPadOS, macOS, tvOS, and watchOS. Writing Swift code is interactive and fun, the syntax is concise yet expressive, and Swift includes modern features developers love. Swift code is safe by design and produces software that runs lightning-fast.' I like cooking because it makes me happy. Indeed I like doing lots of stuff. For example, I just enjoy reading long texts like this one: 'Swift is a powerful and intuitive programming language for iOS, iPadOS, macOS, tvOS, and watchOS. Writing Swift code is interactive and fun, the syntax is concise yet expressive, and Swift includes modern features developers love. Swift code is safe by design and produces software that runs lightning-fast.'",
        rating: 13,
        permalink: "Reddit.com",
        children: []
    )
}
