//
//  CoinListViewController.swift
//  coinApp
//
//  Created by Adjogbe  Tejiri on 20/02/2025.
//

import UIKit
import RxSwift
import RxCocoa

class CoinListViewController: UIViewController, UITableViewDelegate {
    
    var coordinator: AppCoordinator?
    
    private let tableView = UITableView()
    private let viewModel = CoinListViewModel() 
    private let favoritesViewModel: FavoritesViewModel
    private let disposeBag = DisposeBag()
    private var isLoading = true
    private var loadingView = CustomLoadingView()
    
    init(favoritesViewModel: FavoritesViewModel) {
        self.favoritesViewModel = favoritesViewModel
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
        
        loadData()
    }
    
    private func loadData() {
        loadingView.show(in: view)
        isLoading = true
        viewModel.input.onNext(.fetchCoins)
        favoritesViewModel.fetchTrigger.onNext(())
    }
    
    private func setupUI() {
         title = NSLocalizedString("Top 100 Coins", comment: "Coins List Title")
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
         
         let filterControl = UISegmentedControl(items: ["None", "Highest Price", "24h Best"])
         filterControl.selectedSegmentIndex = 0
         filterControl.addTarget(self, action: #selector(filterChanged(_:)), for: .valueChanged)
         navigationItem.titleView = filterControl
    }
    
    @objc private func filterChanged(_ sender: UISegmentedControl) {
         switch sender.selectedSegmentIndex {
         case 1:
             viewModel.input.onNext(.filterCoins(.highestPrice))
         case 2:
             viewModel.input.onNext(.filterCoins(.best24HourPerformance))
         default:
             viewModel.input.onNext(.filterCoins(.none))
         }
    }
    
    private func setupBindings() {
        viewModel.output
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] event in
            guard let self = self else { return }
            loadingView.dismiss()
            isLoading = false
            switch event {
            case .error(let error):
                let errorDialog = CustomErrorDialog(message: error)
                errorDialog.show(in: view)
            default: break
            }
        }).disposed(by: disposeBag)
        
         viewModel.coins
             .bind(to: tableView.rx.items(cellIdentifier: CoinRowTableViewCell.reuseIdentifier,
                                          cellType: CoinRowTableViewCell.self)) { [weak self] row, coin, cell in
                  guard let self = self else { return }
                  let isFav = self.favoritesViewModel.isFavorited(coin: coin)
                  cell.configure(with: coin, isFavorited: isFav) { coin in
                       self.favoritesViewModel.toggleFavoriteTrigger.onNext(coin)
                       self.tableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .automatic)
                  }
             }
             .disposed(by: disposeBag)
         
         favoritesViewModel.favoriteCoins
             .observe(on: MainScheduler.instance)
             .subscribe(onNext: { [weak self] _ in
                  self?.tableView.reloadData()
             })
             .disposed(by: disposeBag)
         
         tableView.rx.contentOffset
             .observe(on: MainScheduler.instance)
             .subscribe(onNext: { [weak self] contentOffset in
                  guard let self = self else { return }
                  let threshold = self.tableView.contentSize.height - self.tableView.frame.size.height - 100
                  if contentOffset.y > threshold, !isLoading {
                      self.viewModel.input.onNext((.fetchCoins))
                  }
             })
             .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(Coin.self)
            .subscribe(onNext: { [weak self] coin in
                guard let self = self else { return }
                self.coordinator?.showCoinDetail(for: coin)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - UITableViewDelegate (for swipe actions)
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
         let currentCoins = viewModel.currentCoins
         guard indexPath.row < currentCoins.count else { return nil }
         let coin = currentCoins[indexPath.row]
         let isFav = favoritesViewModel.isFavorited(coin: coin)
         let actionTitle = isFav ? "Unfavorite" : "Favorite"
         let favoriteAction = UIContextualAction(style: .normal, title: actionTitle) { [weak self] (action, view, completionHandler) in
              self?.favoritesViewModel.toggleFavoriteTrigger.onNext(coin)
              tableView.reloadRows(at: [indexPath], with: .automatic)
              completionHandler(true)
         }
        favoriteAction.backgroundColor = isFav ? .systemRed : .systemBlue
         return UISwipeActionsConfiguration(actions: [favoriteAction])
    }
}
