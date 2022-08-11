//
//  NewsList.swift
//  NewsApp
//
//  Created by Marc Jardine Esperas on 8/10/22.
//

import Foundation

struct NewsList: Decodable {
    let title: String
    let newsList: [News]
    
    enum CodingKeys: String, CodingKey {
        case title
        case newsList = "data"
    }
}

// MARK: - News
struct News: Decodable {
    let id: String?
    let type: NewsType
    let headline, teaserText: String?
    let creationDate, modifiedDate: String?
    let teaserImage: TeaserImage?
    let url, weblinkUrl: String?
}

// MARK: - NewsType
enum NewsType: String, Decodable {
    case story = "story"
    case advert = "advert"
    case weblink = "weblink"
}

// MARK: - TeaserImage
struct TeaserImage: Decodable {
    let links: Links

    enum CodingKeys: String, CodingKey {
        case links = "_links"
    }
}

// MARK: - Links
struct Links: Decodable {
    let url: UrlClass
}

// MARK: - URLClass
struct UrlClass: Codable {
    let href: String
}
