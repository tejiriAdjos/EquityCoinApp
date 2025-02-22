//
//  MockCoinService.swift
//  coinApp
//
//  Created by Adjogbe  Tejiri on 20/02/2025.
//

import Foundation
import RxSwift

class MockCoinService: CoinServiceProtocol {
    var shouldReturnError = false
    
    func fetchTopCoins(page: Int, limit: Int) -> Observable<[Coin]> {
        if shouldReturnError {
            return .error(NSError(domain: "TestError", code: -1, userInfo: nil))
        }
        let mockCoins = [
            Coin(id: "Qwsogvtv82FCd", symbol: "BTC", name: "Bitcoin", iconUrl: nil, price: "40000", marketCap: "756539582864", change: "1.2", sparkline: [], color: ""),
            Coin(id: "razxDUgYGNAdQ", symbol: "ETH", name: "Ethereum", iconUrl: nil, price: "3000", marketCap: "361402349482", change: "2.3", sparkline: [], color: "")
        ]
        return Observable.just(mockCoins)
    }
    
    func fetchCoinDetail(coinId: String) -> Observable<Coin> {
        if shouldReturnError {
            return .error(NSError(domain: "TestError", code: -1, userInfo: nil))
        }
        let mockCoin = Coin(id: coinId, symbol: "BTC", name: "Bitcoin", iconUrl: nil, price: "40000", marketCap: "756539582864", change: "1.2", sparkline: [], color: "")
        return Observable.just(mockCoin)
    }
}
