//
//  UIView+Extensions.swift
//  gitHubUsers
//
//  Created by Veronika Goreva on 26.05.2022.
//

import UIKit

extension UIView {
    
    /// Add conctraints to all superview edges
    func edgesToSuperview() {
        guard let superview = self.superview else { return }
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: superview.topAnchor),
            self.leftAnchor.constraint(equalTo: superview.leftAnchor),
            self.bottomAnchor.constraint(equalTo: superview.bottomAnchor),
            self.rightAnchor.constraint(equalTo: superview.rightAnchor)
        ])
    }
    
    func setupDefaultShadow() {
        layer.shadowColor = Colors.shadowColor.cgColor
        layer.shadowOffset = CGSize(width: 1, height: 3)
        layer.shadowRadius = 5
        layer.shadowOpacity = 0.5
        layer.masksToBounds = false
    }
}
