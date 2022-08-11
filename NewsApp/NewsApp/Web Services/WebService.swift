//
//  WebService.swift
//  NewsApp
//
//  Created by Marc Jardine Esperas on 8/10/22.
//

import Foundation

typealias DefaultWebServiceCompletion = (Result<Data, WebServiceError>) -> ()
typealias NoResponseWebServiceCompletion = (Result<Void, WebServiceError>) -> ()
typealias NewsListWebServiceCompletion = (Result<NewsList, WebServiceError>) -> ()
typealias StoryWebServiceCompletion = (Result<Story, WebServiceError>) -> ()

protocol WebServiceProtocol {
    func fetchNewsListData(completion: @escaping NewsListWebServiceCompletion)
    func fetchStoryData(with newsId: String, completion: @escaping StoryWebServiceCompletion)
    func fetchImageData(with urlString: String, completion: @escaping DefaultWebServiceCompletion)
    func fetchData(with urlString: String, completion: @escaping DefaultWebServiceCompletion)
}

class WebService: WebServiceProtocol {
    private var urlSession: URLSession
    private var cache: CacheManagerProtocol
    
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
        self.cache = CacheManager.shared
    }

    func fetchNewsListData(completion: @escaping NewsListWebServiceCompletion) {
        let urlString = "\(Url.baseUrlString)\(Url.newsListUrl)"
        
        fetchData(with: urlString) { result in
            switch result {
            case .success(let data):
                do {
                    let result = try JSONDecoder().decode(NewsList.self, from: data)
                    completion(.success(result))
                } catch let error {
                    print(error.localizedDescription)
                    completion(.failure(.jsonDecodingError))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func fetchStoryData(with newsId: String, completion: @escaping StoryWebServiceCompletion) {
        let urlString = "\(Url.baseUrlString)\(Url.storyUrl)\(newsId)"
        
        fetchData(with: urlString) { result in
            switch result {
            case .success(let data):
                do {
                    let result = try JSONDecoder().decode(Story.self, from: data)
                    completion(.success(result))
                } catch let error {
                    print("ERROR: \(error)")
                    completion(.failure(.jsonDecodingError))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchImageData(with urlString: String, completion: @escaping DefaultWebServiceCompletion) {
        // check if urlString exists in cache
        if let cachedData = cache.fetch(key: urlString) {
            completion(.success(cachedData))
            return
        }
        
        fetchData(with: urlString) { [weak self] result in
            if case let .success(data) = result {
                completion(.success(data))
                // Save response data to cache
                self?.cache.save(key: urlString, data: data)
            }
            completion(result)
        }
    }
    
    func fetchData(with urlString: String, completion: @escaping DefaultWebServiceCompletion) {
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidUrl))
            return
        }
        
        let dataTask = urlSession.dataTask(with: url) { (data, httpUrlResponse, error) in
            guard error == nil else {
                return completion(.failure(.unableToCompleteRequest))
            }
            
            guard let data = data else {
                return completion(.failure(.invalidData))
            }
            
            completion(.success(data))
        }
        
        dataTask.resume()
    }
}
