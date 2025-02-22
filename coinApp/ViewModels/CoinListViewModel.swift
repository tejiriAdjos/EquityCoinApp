//
//  CoinListViewModel.swift
//  coinApp
//
//  Created by Adjogbe  Tejiri on 20/02/2025.
//

import Foundation
import RxSwift
import RxCocoa

enum CoinFilter {
    case none
    case highestPrice
    case best24HourPerformance
}

class CoinListViewModel {
    
    enum Input {
        case fetchCoins
        case filterCoins(CoinFilter)
    }
    
    enum Output {
        case fetchCoinSuccess
        case filterSuccess
        case error(String)
    }
    
    var coins: Observable<[Coin]>
    private let service: CoinServiceProtocol?
    private let coinsSubject = BehaviorRelay<[Coin]>(value: [])
    let output = PublishSubject<Output>()
    let input = PublishSubject<Input>()
    private var currentFilter: CoinFilter?
    private let disposeBag = DisposeBag()
    
    private var currentPage = 0
    private let limitPerPage = 20
    private let totalCoins = 100
    
    init(service: CoinServiceProtocol = CoinService()) {
        self.coins = coinsSubject.asObservable()
        self.service = service
        input.subscribe(onNext: { [weak self] event in
                guard let self = self else { return }
                switch event {
                case .fetchCoins:
                    self.fetchCoins()
                case .filterCoins(let filter):
                    self.applyFilter(filter)
                }
            }).disposed(by: disposeBag)
    }
    
    private func fetchCoins() {
        guard coinsSubject.value.count <= 100 else { return }
        service?.fetchTopCoins(page: currentPage, limit: limitPerPage)
            .subscribe(
                onNext: { [weak self] newCoins in
                    guard let self = self else { return }
                    let updated = self.coinsSubject.value + newCoins
                    self.coinsSubject.accept(updated)
                    self.currentPage += 1
                    if let currentFilter = self.currentFilter {
                        self.applyFilter(currentFilter)
                    }
                    self.output.onNext(.fetchCoinSuccess)
                },
                onError: { [weak self] error in
                    self?.output.onNext(.error(error.localizedDescription))
                }
            )
            .disposed(by: disposeBag)
    }
    
    private func applyFilter(_ filter: CoinFilter) {
        currentFilter = filter
        var sorted = coinsSubject.value
        switch filter {
        case .highestPrice:
            sorted.sort {
                let p1 = Double($0.price ?? "0") ?? 0
                let p2 = Double($1.price ?? "0") ?? 0
                return p1 > p2
            }
        case .best24HourPerformance:
            sorted.sort {
                let c1 = Double($0.change ?? "0") ?? 0
                let c2 = Double($1.change ?? "0") ?? 0
                return c1 > c2
            }
        case .none:
            break
        }
        coinsSubject.accept(sorted)
    }
    
    var currentCoins: [Coin] {
        return coinsSubject.value
    }
}
