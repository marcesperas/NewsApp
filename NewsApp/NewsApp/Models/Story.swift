//
//  Story.swift
//  NewsApp
//
//  Created by Marc Jardine Esperas on 8/10/22.
//

import Foundation

struct Story: Decodable {
    let headline: String
    let heroImage: HeroImage
    let creationDate, modifiedDate: String
    let contents: [Content]
}

// MARK: - Content
struct Content: Decodable {
    let type: ContentType
    let text, url: String?
}

// MARK: - ContentType
enum ContentType: String, Decodable {
    case paragraph = "paragraph"
    case image = "image"
}

// MARK: - HeroImage
struct HeroImage: Decodable {
    let imageUrl: String
}
