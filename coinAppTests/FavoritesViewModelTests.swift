//
//  FavoritesViewModelTests.swift
//  coinApp
//
//  Created by Adjogbe  Tejiri on 22/02/2025.
//


import XCTest
import RxSwift
import RxBlocking
@testable import coinApp

class FavoritesViewModelTests: XCTestCase {
    var viewModel: FavoritesViewModel!
    var mockService: MockCoinService!
    var disposeBag: DisposeBag!
    
    override func setUp() {
        super.setUp()
        UserDefaults.standard.removeObject(forKey: "favoriteCoinIds")
        mockService = MockCoinService()
        viewModel = FavoritesViewModel(service: mockService)
        disposeBag = DisposeBag()
    }
    
    override func tearDown() {
        viewModel = nil
        mockService = nil
        disposeBag = nil
        super.tearDown()
    }
    
    func testToggleFavorite_AddAndRemove() throws {
        let coin = Coin(id: "1", symbol: "BTC", name: "Bitcoin", iconUrl: nil, price: "40000", marketCap: "700B", change: "2.0", sparkline: [], color: "")
        
        XCTAssertFalse(viewModel.isFavorited(coin: coin))
        
        viewModel.toggleFavoriteTrigger.onNext(coin)
        viewModel.fetchTrigger.onNext(())
        let favsAfterAdd = try viewModel.favoriteCoins.toBlocking(timeout: 2).first()
        XCTAssertTrue(viewModel.isFavorited(coin: coin))
        XCTAssertEqual(favsAfterAdd?.count, 1)
        
        viewModel.toggleFavoriteTrigger.onNext(coin)
        viewModel.fetchTrigger.onNext(())
        let favsAfterRemove = try viewModel.favoriteCoins.toBlocking(timeout: 2).first()
        XCTAssertFalse(viewModel.isFavorited(coin: coin))
        XCTAssertEqual(favsAfterRemove?.count, 0)
    }
}
