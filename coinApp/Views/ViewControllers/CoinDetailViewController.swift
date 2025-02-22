//
//  CoinDetailViewController.swift
//  coinApp
//
//  Created by Adjogbe  Tejiri on 20/02/2025.
//

import UIKit
import RxSwift
import RxCocoa
import SwiftUI

class CoinDetailViewController: UIViewController {
    
    private let state: State
    private let nameLabel = UILabel()
    private let priceLabel = UILabel()
    private let statsLabel = UILabel()
    private let filterSegmentedControl = UISegmentedControl(items: ["1D", "1W", "1M"])
    
    private let chartContainerView = UIView()
    private var chartHostingController: UIHostingController<PerformanceChartView>?
    
    private var performanceData: [Double] = []
    
    let loadingView = CustomLoadingView()
    
    init(coin: Coin) {
        state = State(coin: coin)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupChartHostingController()
    }
    
    private func setupUI() {
         view.backgroundColor = UIColor(named: "BackgroundColor")
        self.nameLabel.text = state.coin.name
        self.priceLabel.text = "Price: \(state.coin.price ?? "N/A")"
        self.statsLabel.text = "24h Change: \(state.coin.change ?? "N/A")%\nMarket Cap: \(state.coin.marketCap ?? "N/A")"
        
        self.updateChartData()
         
         nameLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
         priceLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
         statsLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
         statsLabel.numberOfLines = 0
         
         filterSegmentedControl.selectedSegmentIndex = 0
         filterSegmentedControl.addTarget(self, action: #selector(filterChanged(_:)), for: .valueChanged)
         
         [nameLabel, priceLabel, filterSegmentedControl, chartContainerView, statsLabel].forEach {
             view.addSubview($0)
             $0.translatesAutoresizingMaskIntoConstraints = false
         }
         
         NSLayoutConstraint.activate([
              nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
              nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
              
              priceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
              priceLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
              
              filterSegmentedControl.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 16),
              filterSegmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
              filterSegmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
              
              chartContainerView.topAnchor.constraint(equalTo: filterSegmentedControl.bottomAnchor, constant: 16),
              chartContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
              chartContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
              chartContainerView.heightAnchor.constraint(equalToConstant: 200),
              
              statsLabel.topAnchor.constraint(equalTo: chartContainerView.bottomAnchor, constant: 16),
              statsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
              statsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
         ])
    }
    
    private func setupChartHostingController() {
        performanceData = getPerformanceData()
         let chartView = PerformanceChartView(dataEntries: performanceData)
         let hostingController = UIHostingController(rootView: chartView)
         hostingController.view.backgroundColor = .clear
         hostingController.view.translatesAutoresizingMaskIntoConstraints = false
         addChild(hostingController)
         chartContainerView.addSubview(hostingController.view)
         NSLayoutConstraint.activate([
             hostingController.view.topAnchor.constraint(equalTo: chartContainerView.topAnchor),
             hostingController.view.bottomAnchor.constraint(equalTo: chartContainerView.bottomAnchor),
             hostingController.view.leadingAnchor.constraint(equalTo: chartContainerView.leadingAnchor),
             hostingController.view.trailingAnchor.constraint(equalTo: chartContainerView.trailingAnchor)
         ])
         hostingController.didMove(toParent: self)
         chartHostingController = hostingController
    }
    
    @objc private func filterChanged(_ sender: UISegmentedControl) {
        performanceData = getPerformanceData()
        updateChartData()
    }
    
    private func updateChartData() {
         guard let hostingController = chartHostingController else { return }
         let newChartView = PerformanceChartView(dataEntries: performanceData)
         hostingController.rootView = newChartView
    }
    
    private func getPerformanceData() -> [Double] {
        let performanceData = { state.coin.sparkline?.compactMap { Double($0 ?? "") } }() ?? []
        return performanceData
    }
    
    private struct State {
        let coin: Coin
    }
}
