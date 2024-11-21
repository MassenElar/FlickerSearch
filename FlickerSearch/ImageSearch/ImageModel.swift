//
//  ImageModel.swift
//  FlickerSearch
//
//  Created by Massen Elarabi on 11/20/24.
//

import Foundation

struct ApiResponse: Decodable {
    let items: [ImageModel]
}

struct ImageModel: Decodable, Identifiable {
    
    let id = UUID()
    let title: String
    let media: ImageMedia
    let description: String
    let author: String
    let publishedDate: String
    let tags: String
    
    enum CodingKeys: String, CodingKey {
        case title = "title"
        case media = "media"
        case description = "description"
        case author = "author"
        case publishedDate = "published"
        case tags = "tags"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decode(String.self, forKey: .title)
        self.media = try container.decode(ImageMedia.self, forKey: .media)
        self.author = try container.decode(String.self, forKey: .author)
        self.publishedDate = try container.decode(String.self, forKey: .publishedDate)
        self.tags = try container.decode(String.self, forKey: .tags)
        
        let rawDescription = try container.decode(String.self, forKey: .description)
        self.description = rawDescription.stripHTMLTags()
    }
}

struct ImageMedia: Decodable {
    let imageLink: String
    
    enum CodingKeys: String, CodingKey {
        case imageLink = "m"
    }
}
