//
//  ArticleController.swift
//  Newstack
//
//  Created by Aaron Cleveland on 9/7/20.
//

import Foundation
import CoreData

class ArticleController {
    
    func createArticleEntry(author: String,
                            content: String,
                            publishedAt: String,
                            title: String,
                            url: String,
                            urlToImage: String) {
        let article = Article(author: author,
                              content: content,
                              publishedAt: publishedAt,
                              title: title,
                              url: url,
                              urlToImage: urlToImage)
        
//        put(article: article)
        CoreDataStack.shared.save()
    }
    
    func update(article: Article,
                author: String,
                content: String,
                publishedAt: String,
                title: String,
                url: String,
                urlToImage: String) {
        article.author = author
        article.content = content
        article.publishedAt = publishedAt
        article.title = title
        article.url = url
        article.urlToImage = urlToImage
        CoreDataStack.shared.save()
    }
    
    func delete(article: Article) {
        CoreDataStack.shared.mainContext.delete(article)
        CoreDataStack.shared.save()
    }
}
