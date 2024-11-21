//
//  HtmlFormatter.swift
//  FlickerSearch
//
//  Created by Massen Elarabi on 11/20/24.
//

import Foundation

// Utility to strip HTML tags from a string
extension String {
    func stripHTMLTags() -> String {
        guard let data = self.data(using: .utf8) else { return self }
        do {
            let attributedString = try NSAttributedString(
                data: data,
                options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue],
                documentAttributes: nil)
            return attributedString.string
        } catch {
            return self
        }
    }
}
