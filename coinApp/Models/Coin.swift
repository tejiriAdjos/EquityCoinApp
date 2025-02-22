//
//  Coin.swift
//  coinApp
//
//  Created by Adjogbe  Tejiri on 20/02/2025.
//

import Foundation

struct Coin: Codable, Identifiable, Equatable {
    let id: String 
    let symbol: String
    let name: String
    let iconUrl: String?
    let price: String?
    let marketCap: String?
    let change: String?
    let sparkline: [String?]?
    let color: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "uuid"
        case symbol, name, iconUrl, price, marketCap, change, sparkline, color
    }
}
