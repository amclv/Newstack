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

class NetworkingManager {
    
    var topHeadlinesURL = URLComponents(string:"https://newsapi.org/v2/top-headlines?")!
    var everythingURL = URLComponents(string: "https://newsapi.org/v2/everything?")
    var sourcesURL = URL(string: "https://newsapi.org/v2/sources?") // convenience endpoint for tracking publishers
    
    let secretAPIKey = URLQueryItem(name: "apiKey", value: "569bbdc4ab8c42af93e505b90149e026")
    
//    let search = URLQueryItem(name: "q", value: "uber")
//    let fromDate = URLQueryItem(name: "from", value: "2018-07-14")  // needs to be converted to Date
//    let toDate = URLQueryItem(name: "to", value: "2018-07-17") // needs to be converted to Date
//    let sortBy = URLQueryItem(name: "sortBy", value: SortOptions.publishedAt.rawValue) //should be an enum with options
//    let language = URLQueryItem(name: "language", value: "en")
    let country = URLQueryItem(name: "country", value: "us")
//    let sourcesName = URLQueryItem(name: "sources", value: "bbc-news")
    
    func getHeadlines() {
        topHeadlinesURL.queryItems?.append(country)
        topHeadlinesURL.queryItems?.append(secretAPIKey)
        var request = URLRequest(url: topHeadlinesURL.url!)
        request.httpMethod = HTTPMethod.get.rawValue
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            print(request.url)
            if let error = error {
                print("An error occured", error)
                return
            }
            
            if let data = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        print("json", json)
                    }
                } catch let error {
                    print("Couldn't parse data into JSON", error)
                }
            }
        }.resume()
    }
    
}
