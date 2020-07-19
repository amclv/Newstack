//
//  Sources.swift
//  Newstack
//
//  Created by Aaron Cleveland on 7/19/20.
//

import Foundation

struct PaperSource: Codable {
    var status: String?
    var sources: [Sources]
    
    struct Sources: Codable {
        var id: String?
        var name: String?
        var description: String?
        var url: URL?
        var category: String?
        var language: String?
        var country: String?
    }
}
