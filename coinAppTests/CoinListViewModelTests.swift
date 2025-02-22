//
//  CoinListViewModelTests.swift
//  coinApp
//
//  Created by Adjogbe  Tejiri on 20/02/2025.
//

import XCTest
import RxSwift
import RxBlocking
@testable import coinApp


class CoinListViewModelTests: XCTestCase {
    var viewModel: CoinListViewModel!
    var mockService: MockCoinService!
    var disposeBag: DisposeBag!
    
    override func setUp() {
        super.setUp()
        mockService = MockCoinService()
        viewModel = CoinListViewModel(service: mockService)
        disposeBag = DisposeBag()
    }
    
    override func tearDown() {
        viewModel = nil
        mockService = nil
        disposeBag = nil
        super.tearDown()
    }
    
    func testFetchCoinsSuccess() throws {
        viewModel.input.onNext(.fetchCoins)
        
        let coins = try viewModel.coins.toBlocking(timeout: 2).first()
        XCTAssertNotNil(coins)
        XCTAssertEqual(coins?.count, 2)
    }
    
    func testFilterHighestPrice() throws {
        viewModel.input.onNext(.fetchCoins)
        
        viewModel.input.onNext(.filterCoins(.highestPrice))
        
        let coins = try viewModel.coins.toBlocking(timeout: 2).first()
        XCTAssertNotNil(coins)
        if let firstCoin = coins?.first {
            XCTAssertEqual(firstCoin.price, "40000")
        }
    }
}
