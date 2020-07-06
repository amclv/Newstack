//
//  News.swift
//  Newstack
//
//  Created by Aaron Cleveland on 6/25/20.
//

import Foundation

struct NewsFeed: Codable {
    var status: String = ""
    var totalResults: Int = 0
    var articles: [Article]?
}

