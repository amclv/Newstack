//
//  Article.swift
//  Newstack
//
//  Created by Aaron Cleveland on 7/6/20.
//

import Foundation

struct Article: Codable {
    var article: String?
    var title: String?
    var description: String?
    var url: String?
    var urlToImage: String?
    var publishedAt: String?
    var content: String?
    
//    var formattedDate: String {
//        guard let publishedAt = publishedAt else { return "" }
//        let df = DateFormatter()
//        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
//        guard let publishedDate = df.date(from: publishedAt) else { return "" }
//        df.dateStyle = .long
//        df.timeStyle = .short
//        df.locale = .current
//        let dateString = df.string(from: publishedDate)
//        return dateString
//    }
}
