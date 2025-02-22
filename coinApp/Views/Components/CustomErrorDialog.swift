//
//  CustomErrorDialog.swift
//  coinApp
//
//  Created by Adjogbe  Tejiri on 23/02/2025.
//


import UIKit

class CustomErrorDialog: UIView {
    private let containerView = UIView()
    private let messageLabel = UILabel()
    private let dismissButton = UIButton(type: .system)
    
    var dismissAction: (() -> Void)?
    
    init(message: String) {
        super.init(frame: .zero)
        setupView(message: message)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView(message: String) {
        backgroundColor = UIColor(white: 0, alpha: 0.5)
        
        containerView.backgroundColor = .systemBackground
        containerView.layer.cornerRadius = 12
        containerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(containerView)
        
        messageLabel.text = message
        messageLabel.textColor = .label
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(messageLabel)
        
        dismissButton.setTitle("OK", for: .normal)
        dismissButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(dismissButton)
        
        dismissButton.addTarget(self, action: #selector(dismissTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            containerView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            containerView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 280),
            
            messageLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            messageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            
            dismissButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 20),
            dismissButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20),
            dismissButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)
        ])
    }
    
    @objc private func dismissTapped() {
        dismissAction?()
        dismiss()
    }
    
    func show(in view: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(self)
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: view.topAnchor),
            self.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            self.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        self.alpha = 0
        UIView.animate(withDuration: 0.3) {
            self.alpha = 1
        }
    }
    
    func dismiss() {
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0
        }) { _ in
            self.removeFromSuperview()
        }
    }
}
