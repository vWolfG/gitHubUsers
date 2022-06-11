//
//  CopyableLabel.swift
//  gitHubUsers
//
//  Created by Veronika Goreva on 05.06.2022.
//

import UIKit

/// Allow to copy the content form the UILabel
class CopyableLabel: UILabel {
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private
    
    private func setupUI() {
        isUserInteractionEnabled = true
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(showMenu))
        addGestureRecognizer(gesture)
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func copy(_ sender: Any?) {
        UIPasteboard.general.string = text
        UIMenuController.shared.hideMenu()
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return (action == #selector(copy(_:)))
    }
    
    @objc
    private func showMenu() {
        becomeFirstResponder()
        let menu = UIMenuController.shared
        if !menu.isMenuVisible {
            menu.showMenu(from: self, rect: bounds)
        }
    }
}
