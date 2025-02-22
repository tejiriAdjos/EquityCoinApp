//
//  FavoritesViewController.swift
//  coinApp
//
//  Created by Adjogbe  Tejiri on 20/02/2025.
//

import UIKit
import RxSwift
import RxCocoa

class FavoritesViewController: UIViewController, UITableViewDelegate {
    
    var coordinator: AppCoordinator?
    
    private let tableView = UITableView()
    private let viewModel: FavoritesViewModel
    private let disposeBag = DisposeBag()
    
    private var currentFavorites: [Coin] = []
    
    init(viewModel: FavoritesViewModel) {
         self.viewModel = viewModel
         super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
         super.viewDidLoad()
         setupUI()
        tableView.delegate = self
         setupBindings()
         viewModel.fetchTrigger.onNext(())
    }
    
    private func setupUI() {
         title = NSLocalizedString("Favorites", comment: "Favorites Title")
         view.backgroundColor = UIColor(named: "BackgroundColor")
         tableView.register(CoinRowTableViewCell.self, forCellReuseIdentifier: CoinRowTableViewCell.reuseIdentifier)
         tableView.translatesAutoresizingMaskIntoConstraints = false
         view.addSubview(tableView)
         NSLayoutConstraint.activate([
              tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
              tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
              tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
              tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
         ])
    }
    
    private func setupBindings() {
         viewModel.favoriteCoins
             .observe(on: MainScheduler.instance)
             .subscribe(onNext: { [weak self] favs in
                 self?.currentFavorites = favs
             })
             .disposed(by: disposeBag)
         
         viewModel.favoriteCoins
             .bind(to: tableView.rx.items(cellIdentifier: CoinRowTableViewCell.reuseIdentifier,
                                          cellType: CoinRowTableViewCell.self)) { row, coin, cell in
                  cell.configure(with: coin, isFavorited: true) { _ in }
             }
             .disposed(by: disposeBag)
         
        tableView.rx.modelSelected(Coin.self)
            .subscribe(onNext: { coin in
                self.coordinator?.showCoinDetail(for: coin)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - UITableViewDelegate (swipe action to unfavorite)
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
         guard indexPath.row < currentFavorites.count else { return nil }
         let coin = currentFavorites[indexPath.row]
         let unfavoriteAction = UIContextualAction(style: .destructive, title: "Unfavorite") { [weak self] action, view, completionHandler in
              self?.viewModel.toggleFavoriteTrigger.onNext(coin)
              completionHandler(true)
         }
         return UISwipeActionsConfiguration(actions: [unfavoriteAction])
    }
}
