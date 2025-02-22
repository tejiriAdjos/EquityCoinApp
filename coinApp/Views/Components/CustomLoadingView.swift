//
//  CustomLoadingView.swift
//  coinApp
//
//  Created by Adjogbe  Tejiri on 23/02/2025.
//


import UIKit

class CustomLoadingView: UIView {
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let messageLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = UIColor(white: 0, alpha: 0.7)
        layer.cornerRadius = 10
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        addSubview(activityIndicator)
        
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.textColor = .white
        messageLabel.font = UIFont.boldSystemFont(ofSize: 16)
        messageLabel.text = "Loading..."
        addSubview(messageLabel)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            activityIndicator.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            messageLabel.topAnchor.constraint(equalTo: activityIndicator.bottomAnchor, constant: 12),
            messageLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            messageLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20)
        ])
    }
    
    func show(in view: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(self)
        NSLayoutConstraint.activate([
            self.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            self.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            self.widthAnchor.constraint(equalToConstant: 140),
            self.heightAnchor.constraint(equalToConstant: 140)
        ])
        activityIndicator.startAnimating()
    }
    
    func dismiss() {
        activityIndicator.stopAnimating()
        self.removeFromSuperview()
    }
}
