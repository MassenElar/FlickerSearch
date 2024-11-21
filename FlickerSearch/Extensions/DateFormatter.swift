//
//  DateFormatter.swift
//  FlickerSearch
//
//  Created by Massen Elarabi on 11/20/24.
//

import Foundation

extension String {
    func toFormattedDate(format: String = "MMM dd, yyyy") -> String {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.timeZone = TimeZone(secondsFromGMT: 0)

        guard let date = isoFormatter.date(from: self) else {
            return self // Return the original string if parsing fails
        }

        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = format
        return outputFormatter.string(from: date)
    }
}
