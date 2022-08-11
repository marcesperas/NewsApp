//
//  StoryViewModel.swift
//  NewsApp
//
//  Created by Marc Jardine Esperas on 8/10/22.
//

import Foundation

protocol StoryViewModelProtocol {
    func fetchStory(completion: @escaping NoResponseWebServiceCompletion)
    func fetchImageData(with urlString: String?, completion: @escaping DefaultWebServiceCompletion)
}

class StoryViewModel: StoryViewModelProtocol {
    private var webService: WebServiceProtocol
    private var newsId: String
    private var story: Story?
    
    init(webService: WebServiceProtocol = WebService(),
         newsId: String) {
        self.webService = webService
        self.newsId = newsId
    }
    
    public var headline: String {
        return story?.headline ?? ""
    }

    public var imageUrl: String {
        return story?.heroImage.imageUrl ?? ""
    }
    
    public func getReuseIdentifier(_ contentType: ContentType) -> String {
        switch contentType {
            case .paragraph:
                return "paragraphCell"
            default:
                return "imageCell"
        }
    }
    
    public func numberOfItemsInSection(_ section: Int) -> Int {
        return story?.contents.count ?? 0
    }
    
    public func contentAtIndex(_ index: Int) -> Content? {
        return story?.contents[index]
    }
    
    func fetchStory(completion: @escaping NoResponseWebServiceCompletion) {
        webService.fetchStoryData(with: newsId) { [weak self] result in
            switch result {
            case .success(let story):
                self?.story = story
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func fetchImageData(with urlString: String?, completion: @escaping DefaultWebServiceCompletion) {
        webService.fetchImageData(with: urlString ?? "", completion: completion)
    }
}
