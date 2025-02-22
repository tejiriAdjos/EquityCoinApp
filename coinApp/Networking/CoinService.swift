//
//  CoinService.swift
//  coinApp
//
//  Created by Adjogbe  Tejiri on 20/02/2025.
//

import Foundation
import RxSwift

class CoinService: CoinServiceProtocol {
    private let client: HTTPClient
    
    init(client: HTTPClient = .shared) {
        self.client = client
    }
    
    func fetchTopCoins(page: Int, limit: Int) -> Observable<[Coin]> {
        let urlPath = "/coins?limit=\(limit)&offset=\(page)"
        return client.request(urlPath).map { (response: APIResponse<CoinListData>) in response.data.coins }
    }
    
    func fetchCoinDetail(coinId: String) -> Observable<Coin> {
        let urlPath = "/coin/\(coinId)"
        return client.request(urlPath).map { (response: APIResponse<DetailData>) in response.data.coin }
    }
}
