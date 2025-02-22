//
//  FavoritesViewModel.swift
//  coinApp
//
//  Created by Adjogbe  Tejiri on 20/02/2025.
//

import Foundation
import RxSwift
import RxCocoa

class FavoritesViewModel {
    let fetchTrigger = PublishSubject<Void>()
    let toggleFavoriteTrigger = PublishSubject<Coin>()
    
    let favoriteCoins: Observable<[Coin]>
    
    private let favoritesSubject = BehaviorRelay<[Coin]>(value: [])
    private let disposeBag = DisposeBag()
    private let service: CoinServiceProtocol
    
    private var favorites: [Coin] = []
    
    init(service: CoinServiceProtocol = CoinService()) {
        self.service = service
        self.favoriteCoins = favoritesSubject.asObservable()
        
        fetchTrigger
            .subscribe(onNext: { [weak self] in
                self?.loadFavorites()
            })
            .disposed(by: disposeBag)
        
        toggleFavoriteTrigger
            .subscribe(onNext: { [weak self] coin in
                self?.toggleFavorite(coin: coin)
            })
            .disposed(by: disposeBag)
    }
    
    private func loadFavorites() {
        let savedIds = UserDefaults.standard.stringArray(forKey: Keys.COIN_VAULT_KEY) ?? []
        let observables = savedIds.map { service.fetchCoinDetail(coinId: $0) }
        Observable.zip(observables)
            .subscribe(onNext: { [weak self] coins in
                self?.favorites = coins
                self?.favoritesSubject.accept(coins)
            })
            .disposed(by: disposeBag)
    }
    
    private func toggleFavorite(coin: Coin) {
        var savedIds = UserDefaults.standard.stringArray(forKey: Keys.COIN_VAULT_KEY) ?? []
        if savedIds.contains(coin.id) {
            savedIds.removeAll { $0 == coin.id }
            favorites.removeAll { $0.id == coin.id }
        } else {
            savedIds.append(coin.id)
            favorites.append(coin)
        }
        UserDefaults.standard.set(savedIds, forKey: Keys.COIN_VAULT_KEY)
        favoritesSubject.accept(favorites)
    }
    
    func isFavorited(coin: Coin) -> Bool {
        let savedIds = UserDefaults.standard.stringArray(forKey: Keys.COIN_VAULT_KEY) ?? []
        return savedIds.contains(coin.id)
    }
    
    struct Keys {
        static let COIN_VAULT_KEY = "favoriteCoinIds"
    }
}
