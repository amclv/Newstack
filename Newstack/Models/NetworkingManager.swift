//
//  NetworkingManager.swift
//  Newstack
//
//  Created by Aaron Cleveland on 7/5/20.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case delete = "DELETE"
}

enum SortOptions: String {
    case relevancy // articles more closely related to q come first.
    case popularity // articles from popular sources and publishers come first.
    case publishedAt // newest articles come first.
}

class NetworkingManager {
    
    var myFeed: [NewsSource.Article] = []
    let url = URL(string: "https://newsapi.org/v2/everything?q=trump&apiKey=569bbdc4ab8c42af93e505b90149e026")
    
    func fetchNews(completionHandler: @escaping () -> Void) {
        let request = URLRequest(url: url!)
        
        URLSession.shared.dataTask(with: request) { (data, _, _) in
            let decoder = JSONDecoder()
            do {
                let source = try decoder.decode(NewsSource.self, from: data!)
                let articles = source.articles
                self.myFeed = articles
                DispatchQueue.main.async {
                    completionHandler()
                }
            } catch {
                print("Error decoding: \(error)")
            }
        }.resume()
    }
    
    func fetchImage(imageURL: URL, completionHandler: @escaping (Data) -> Void) {
        let imageRequest = URLRequest(url: imageURL)
        
        URLSession.shared.dataTask(with: imageRequest) { (data, _, _) in
            guard let data = data else { return }
            DispatchQueue.main.async {
                completionHandler(data)                
            }
        }.resume()
    }
}

