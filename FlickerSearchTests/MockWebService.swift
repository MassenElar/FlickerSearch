//
//  ImageSearchView.swift
//  FlickerSearch
//
//  Created by Massen Elarabi on 11/20/24.
//

import Foundation
@testable import FlickerSearch

extension ApiResponse {
    static func build(searchItem: String) async throws -> ApiResponse? {
        print("massen here 1")
        let jsonFile = """
           {
               "items": [
                   {
                       "title": "title1",
                       "description": "description1",
                       "media": {
                           "m": "www.image1.com"
                       },
                       "author": "author1",
                       "published": "2024-11-20T03:14:34Z",
                       "tags": "dog cat tiger"
                   },
                   {
                       "title": "title2",
                       "description": "description2</b><p>",
                       "media": {
                           "m": "www.image2.com"
                       },
                       "author": "author2",
                       "published": "2024-12-20T03:14:34Z",
                       "tags": "dog cat tree"
                   },
                   {
                       "title": "title3",
                       "description": "description3",
                       "media": {
                           "m": "www.image3.com"
                       },
                       "author": "author3",
                       "published": "2024-9-20T03:14:34Z",
                       "tags": "dog tree tiger"
                   }
               ]
           }
       """.data(using: .utf8)!
       
        do {
            let response = try JSONDecoder().decode(ApiResponse.self, from: jsonFile)
            let result = response.items.filter { image in
                return containsWord(word: searchItem, tags: image.tags)
            }
            print("massen \(result)")
            return ApiResponse(items: result)
            
        } catch {
            print("Error decoding JSON: \(error)")
            return nil
        }
       
   }
    
    static func containsWord(word: String, tags: String) -> Bool {
            let words = tags.split(separator: " ").map { String($0) }
            return words.contains(where: { $0.caseInsensitiveCompare(word) == .orderedSame })
    }
}

struct MockWebServiceSuccess: ImageSearchWebServiceProtocol {
    func fetchImages(searchItem: String) async throws -> ApiResponse {
        return try await ApiResponse.build(searchItem: searchItem)!
    }
}

struct MockWebServiceFail: ImageSearchWebServiceProtocol {
    func fetchImages(searchItem: String) async throws -> ApiResponse {
        throw APIError.httpStatusCode(400)
    }
}
