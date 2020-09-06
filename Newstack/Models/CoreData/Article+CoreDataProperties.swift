//
//  Article+CoreDataProperties.swift
//  Newstack
//
//  Created by Aaron Cleveland on 9/6/20.
//
//

import Foundation
import CoreData


extension Article {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Article> {
        return NSFetchRequest<Article>(entityName: "Article")
    }

    @NSManaged public var author: String?
    @NSManaged public var title: String?
    @NSManaged public var url: URL?
    @NSManaged public var urlToImage: URL?
    @NSManaged public var publishedAt: String?
    @NSManaged public var content: String?

}
