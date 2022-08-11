//
//  NewsListViewModel.swift
//  NewsApp
//
//  Created by Marc Jardine Esperas on 8/10/22.
//

import Foundation

protocol NewsListViewModelProtocol {
    func fetchNewsList(completion: @escaping NoResponseWebServiceCompletion)
    func fetchImageData(with urlString: String?, completion: @escaping DefaultWebServiceCompletion)
}

class NewsListViewModel: NewsListViewModelProtocol {
    private var webService: WebServiceProtocol
    private var newsList: [News] = []
    
    init(webService: WebServiceProtocol = WebService()) {
        self.webService = webService
    }
    
    public func getReuseIdentifierAt(_ index: Int) -> String {
        if index == 0 {
            return "mainNewsCell"
        }
        
        return "newsCell"
    }
    
    public func showDate(_ news: News) -> String {
        if let stringDate = news.creationDate,
           let date = stringDate.apiDate() {
            return date.timeAgoDisplay()
        }
        return ""
    }
    
    public func numberOfItemsInSection(_ section: Int) -> Int {
        return newsList.count
    }
    
    public func newsAtIndex(_ index: Int) -> News {
        return newsList[index]
    }
    
    func fetchNewsList(completion: @escaping NoResponseWebServiceCompletion) {
        webService.fetchNewsListData { [weak self] result in
            switch result {
            case .success(let newsList):
                self?.newsList = newsList.newsList
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchImageData(with urlString: String?, completion: @escaping DefaultWebServiceCompletion) {
        webService.fetchImageData(with: urlString ?? "", completion: completion)
    }
}
