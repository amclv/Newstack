//
//  Article+Convenience.swift
//  Newstack
//
//  Created by Aaron Cleveland on 9/7/20.
//

import Foundation
import CoreData

extension Article {
    convenience init(author: String, content: String, publishedAt: String, title: String, url: String, urlToImage: String, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.author = author
        self.content = content
        self.publishedAt = publishedAt
        self.title = title
        self.url = url
        self.urlToImage = urlToImage
    }
}
