//
//  Model.swift
//  exchange_rate_calculator
//
//  Created by kiakim on 1/19/24.
//

import Foundation

struct ExchangeRateResponse: Decodable {
    let success: Bool
    let terms: URL
    let privacy: URL
    let timestamp: Int
    let source: String
    let quotes: [String: Double]

    private enum CodingKeys: String, CodingKey {
        case success, terms, privacy, timestamp, source, quotes
    }
}
