//
//  APIResponse.swift
//  coinApp
//
//  Created by Adjogbe  Tejiri on 23/02/2025.
//


struct APIResponse<T: Decodable>: Decodable {
    let status: String
    let data: T
}

struct CoinListData: Decodable {
    let coins: [Coin]
}

struct DetailData: Decodable {
    let coin: Coin
}
