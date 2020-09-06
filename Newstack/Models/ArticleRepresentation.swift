//
//  Article.swift
//  Newstack
//
//  Created by Aaron Cleveland on 7/6/20.
//

import Foundation

struct NewsSource: Codable {
    let status: String?
    let totalResults: Int?
    let articles: [ArticleRepresentation]
}

struct ArticleRepresentation: Codable {
    let source: Source
    let author: String?
    let title: String?
    let description: String?
    let url: URL?
    let urlToImage: URL?
    
    var formattedDate: String {
        guard let publishedAt = publishedAt else { return "" }
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        guard let publishedDate = df.date(from: publishedAt) else { return "" }
        df.dateStyle = .long
        df.timeStyle = .short
        df.locale = .current
        let dateString = df.string(from: publishedDate)
        return dateString
    }
    
    let publishedAt: String?
    let content: String?
}

struct Source: Codable {
    let id: String?
    let name: String?
}
