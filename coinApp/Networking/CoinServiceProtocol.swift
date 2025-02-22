//
//  CoinServiceProtocol.swift
//  coinApp
//
//  Created by Adjogbe  Tejiri on 20/02/2025.
//

import Foundation
import RxSwift

protocol CoinServiceProtocol {
    func fetchTopCoins(page: Int, limit: Int) -> Observable<[Coin]>
    func fetchCoinDetail(coinId: String) -> Observable<Coin>
}
