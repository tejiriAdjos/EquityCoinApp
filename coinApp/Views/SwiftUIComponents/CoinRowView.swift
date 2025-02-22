//
//  CoinRowView.swift
//  coinApp
//
//  Created by Adjogbe  Tejiri on 20/02/2025.
//

import SwiftUI
import SDWebImageSwiftUI

struct CoinRowView: View {
    let coin: Coin
    let isFavorited: Bool
    var onFavoriteTapped: ((Coin) -> Void)?
    
    var body: some View {
        HStack {
            if let urlString = coin.iconUrl, let url = URL(string: urlString) {
                WebImage(url: url, options: [.progressiveLoad]) { image in
                    image.resizable()
                } placeholder: {
                    Image(systemName: "photo")
                        .frame(width: 40, height: 40)
                }
                .indicator(.activity)
                .transition(.fade(duration: 0.5))
                .scaledToFit()
                .frame(width: 40, height: 40)
                .cornerRadius(20)
            } else {
                Image(systemName: "photo")
                    .frame(width: 40, height: 40)
            }
            
            VStack(alignment: .leading) {
                Text(coin.name)
                    .font(.headline)
                Text("Price: \(coin.price ?? "N/A")")
                    .font(.subheadline)
            }
            Spacer()
            Text("\(coin.change ?? "N/A")%")
                .font(.subheadline)
                .foregroundColor((Double(coin.change ?? "0") ?? 0) >= 0 ? .green : .red)
            Button(action: {
                onFavoriteTapped?(coin)
            }) {
                Image(systemName: isFavorited ? "star.fill" : "star")
                    .foregroundColor(isFavorited ? .yellow : .gray)
            }
            .buttonStyle(BorderlessButtonStyle())
        }
        .padding(.vertical, 8)
    }
}
