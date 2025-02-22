//
//  CoinRowTableViewCell.swift
//  coinApp
//
//  Created by Adjogbe  Tejiri on 20/02/2025.
//

import UIKit
import SwiftUI

class CoinRowTableViewCell: UITableViewCell {
    static let reuseIdentifier = "CoinRowTableViewCell"
    
    private var hostingController: UIHostingController<CoinRowView>?
    
    func configure(with coin: Coin, isFavorited: Bool, onFavoriteTapped: @escaping (Coin) -> Void) {
        let coinRowView = CoinRowView(coin: coin, isFavorited: isFavorited, onFavoriteTapped: onFavoriteTapped)
        if let hostingController = hostingController {
            hostingController.rootView = coinRowView
        } else {
            let hostingController = UIHostingController(rootView: coinRowView)
            hostingController.view.backgroundColor = .clear
            hostingController.view.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(hostingController.view)
            NSLayoutConstraint.activate([
                hostingController.view.topAnchor.constraint(equalTo: contentView.topAnchor),
                hostingController.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                hostingController.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                hostingController.view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
            ])
            self.hostingController = hostingController
        }
    }
}
