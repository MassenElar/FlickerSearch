//
//  ImageSearchWebService.swift
//  FlickerSearch
//
//  Created by Massen Elarabi on 11/20/24.
//
import Foundation

/// API Errors
public enum APIError: Swift.Error {
    case invalidURL
    case httpStatusCode(Int)
    case unexpectedResponse
}

// Extension for API Error

extension APIError: LocalizedError {

    public var errorDescription: String? {
        switch self {
            case .invalidURL: return "Invalid URL"
            case let .httpStatusCode(code): return "Unexpected HTTP status code: \(code)"
            case .unexpectedResponse: return "Unexpected response from the server"
        }
    }
}

// MARK: - Flicker Images web service protocol

protocol ImageSearchWebServiceProtocol {
    // Fetch images
    func fetchImages(searchItem: String) async throws -> ApiResponse
}

// MARK: - Flicker Images Web Service

public struct ImageSearchWebService: ImageSearchWebServiceProtocol {
    
    private let urlSession: URLSession
    private let baseURL = "https://api.flickr.com/services/feeds/photos_public.gne?format=json&nojsoncallback=1&tags="
    
    init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    func fetchImages(searchItem: String) async throws -> ApiResponse {
        let urlStr = baseURL + searchItem
        guard let url = URL(string: urlStr) else { throw APIError.invalidURL }
        return try await callAPI(url: url)
    }
    
    public func callAPI<Model>(url: URL) async throws -> Model where Model: Decodable {
        let (data, response) = try await urlSession.data(from: url)
        guard let response = response as? HTTPURLResponse else {
            throw APIError.unexpectedResponse
        }
        let statusCode = response.statusCode
        guard (200...299).contains(statusCode) else {
            throw APIError.httpStatusCode(statusCode)
        }
        do {
            let jsonData = String(decoding: data, as: UTF8.self).data(using: .utf8)!
            let decodedData = try JSONDecoder().decode(Model.self, from: jsonData)
            return decodedData
        } catch let error {
            throw error
        }
    }
}

