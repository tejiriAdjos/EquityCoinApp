//
//  Coordinator.swift
//  coinApp
//
//  Created by Adjogbe  Tejiri on 23/02/2025.
//


import UIKit

protocol Coordinator {
    var navigationController: UINavigationController { get set }
    func start()
}

class AppCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let favoritesViewModel = FavoritesViewModel()
        
        let coinListVC = CoinListViewController(favoritesViewModel: favoritesViewModel)
        coinListVC.coordinator = self
        let coinNav = UINavigationController(rootViewController: coinListVC)
        coinNav.tabBarItem = UITabBarItem(title: "Coins", image: UIImage(systemName: "bitcoinsign.circle"), tag: 0)
        
        let favoritesVC = FavoritesViewController(viewModel: favoritesViewModel)
        favoritesVC.coordinator = self
        let favoritesNav = UINavigationController(rootViewController: favoritesVC)
        favoritesNav.tabBarItem = UITabBarItem(title: "Favorites", image: UIImage(systemName: "star.fill"), tag: 1)
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [coinNav, favoritesNav]
        
        navigationController.setViewControllers([tabBarController], animated: false)
    }
    
    func showCoinDetail(for coin: Coin) {
        let detailVC = CoinDetailViewController(coin: coin)
        navigationController.pushViewController(detailVC, animated: true)
    }
}
