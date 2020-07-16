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
    
    var headlineFeed: [NewsSource.Article] = []
    var everythingFeed: [NewsSource.Article] = []
    var searchResult: [NewsSource.Article] = []
    
    let headlineURL = URL(string: "https://newsapi.org/v2/top-headlines?")!
    let everythingURL = URL(string: "https://newsapi.org/v2/everything?")!
    let sourcesURL = URL(string: "https://newsapi.org/v2/sources?")
    let secretAPI = URLQueryItem(name: "apiKey", value: "569bbdc4ab8c42af93e505b90149e026")
    
    let sortBy = URLQueryItem(name: "sortBy", value: SortOptions.publishedAt.rawValue)
    let sourcesName = URLQueryItem(name: "sources", value: "bbc-news")
    let country = URLQueryItem(name: "country", value: "us")
    let language = URLQueryItem(name: "language", value: "en")
    
    let category = URLQueryItem(name: "category", value: "general")
    
    func performSearch(searchTerm: String, completionHandler: @escaping (_ error: Error?) -> Void) {
        let search = URLQueryItem(name: "q", value: searchTerm)
        
        var urlComponents = URLComponents(url: everythingURL, resolvingAgainstBaseURL: true)
        urlComponents?.queryItems?.append(search)
        urlComponents?.queryItems?.append(secretAPI)
        
        guard let requestURL = urlComponents?.url else {
            print("request URL is nil in fetchNews")
            completionHandler(nil)
            return
        }
        print("functioning in performSearch")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.get.rawValue

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                print("Error fetching data: \(error)")
                return
            }

            guard let data = data else {
                print("No data return from data task")
                return
            }

            let jsonDecoder = JSONDecoder()
            do {
                let searchResult = try jsonDecoder.decode(NewsSource.self, from: data)
                self.searchResult.append(contentsOf: searchResult.articles)
                DispatchQueue.main.async {
                    completionHandler(nil)
                }
            } catch {
                print("Unable to decode data into objects of type [NewsSource.Article]: \(error)")
            }
            completionHandler(nil)
        }
        .resume()
    }
    
    func fetchNews(completionHandler: @escaping () -> Void) {
        var urlComponents = URLComponents(url: headlineURL, resolvingAgainstBaseURL: true)
        urlComponents?.queryItems?.append(category)
//        urlComponents?.queryItems?.append(country)
        urlComponents?.queryItems?.append(secretAPI)
        
        guard let requestURL = urlComponents?.url else {
            print("request URL is nil in fetchNews")
            completionHandler()
            return
        }
        print("functioning in fetchNews")
        
        URLSession.shared.dataTask(with: requestURL) { (data, _, _) in
            let decoder = JSONDecoder()
            do {
                let source = try decoder.decode(NewsSource.self, from: data!)
                let articles = source.articles
                self.headlineFeed = articles
                DispatchQueue.main.async {
                    completionHandler()
                }
            } catch {
                print("Error decoding: \(error)")
            }
        }.resume()
    }
    
    func fetchEverything(completionHandler: @escaping () -> Void) {
        var urlComponents = URLComponents(url: everythingURL, resolvingAgainstBaseURL: true)
        urlComponents?.queryItems?.append(sourcesName)
        urlComponents?.queryItems?.append(secretAPI)
        
        guard let requestURL = urlComponents?.url else {
            print("request URL is nil in fetchEverything")
            completionHandler()
            return
        }
        print("functioning in fetchEverything")
        
        URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
            if let error = error {
                print("error: \(error)")
                completionHandler()
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let source = try decoder.decode(NewsSource.self, from: data!)
                let articles = source.articles
                self.everythingFeed = articles
                DispatchQueue.main.async {
                    completionHandler()
                }
            } catch {
                print("Error decoding everything url: \(error)")
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

