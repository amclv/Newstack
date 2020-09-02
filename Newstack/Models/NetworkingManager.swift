//
//  NetworkingManager.swift
//  Newstack
//
//  Created by Aaron Cleveland on 7/5/20.
//
/*
 Endpoints
 News API has 2 main endpoints:

 Top headlines /v2/top-headlines - returns breaking news headlines for a country and category, or currently running on a single or multiple sources. This is perfect for use with news tickers or anywhere you want to display live up-to-date news headlines and images.
 Everything /v2/everything - we index every recent news and blog article published by over 50,000 different sources large and small, and you can search through them with this endpoint. This endpoint is better suited for news analysis and article discovery, but can be used to retrieve articles for display too.
 We also have a minor endpoint that can be used to retrieve a small subset of the publishers we index from:

 Sources /v2/sources - returns information (including name, description, and category) about the most notable sources we index. This list could be piped directly through to your users when showing them some of the options available.
 */

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
    var sourcesFeed: [PaperSource.Sources] = []
    
    let headlineURL = URL(string: "https://newsapi.org/v2/top-headlines?")!
    let everythingURL = URL(string: "https://newsapi.org/v2/everything?")!
    let sourcesURL = URL(string: "https://newsapi.org/v2/sources?")!
    let secretAPI = URLQueryItem(name: "apiKey", value: "569bbdc4ab8c42af93e505b90149e026")
    
    let sortBy = URLQueryItem(name: "sortBy", value: SortOptions.publishedAt.rawValue)
    let search = URLQueryItem(name: "q", value: "trump")
    let fromDate = URLQueryItem(name: "from", value: "2018-01-01")
    let toDate = URLQueryItem(name: "to", value: "2019-01-01")
    let language = URLQueryItem(name: "language", value: "en")
    let country = URLQueryItem(name: "country", value: "us")
    
    let domains = URLQueryItem(name: "domains", value: "techcrunch.com")
    
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
    
    func fetchHeadlines(sources: String, completionHandler: @escaping () -> Void) {
        let sourcesName = URLQueryItem(name: "sources", value: sources)
        var urlComponents = URLComponents(url: headlineURL, resolvingAgainstBaseURL: true)
        urlComponents?.queryItems?.append(sourcesName)
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
    
    func fetchEverything(sources: String, completionHandler: @escaping () -> Void) {
        let sourcesName = URLQueryItem(name: "sources", value: sources)
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
    
    func fetchSources(completionHandler: @escaping () -> Void) {
        var urlComponents = URLComponents(url: sourcesURL, resolvingAgainstBaseURL: true)
        urlComponents?.queryItems?.append(language)
        urlComponents?.queryItems?.append(secretAPI)
        
        guard let requestURL = urlComponents?.url else {
            print("request url is nil in fetchSources")
            completionHandler()
            return
        }
        print("fetchSources is functionings")
        
        URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
            if let error = error {
                print("Error: \(error)")
                completionHandler()
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let source = try decoder.decode(PaperSource.self, from: data!)
                let newSource = source.sources
                self.sourcesFeed = newSource
                DispatchQueue.main.async {
                    completionHandler()
                }
            } catch {
                print("Error decoding sources url: \(error)")
            }
        }.resume()
    }
}

