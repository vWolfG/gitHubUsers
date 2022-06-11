//
//  AlertPresentable.swift
//  gitHubUsers
//
//  Created by Veronika Goreva on 31.05.2022.
//

import Foundation
import UIKit

protocol AlertPresentable: AnyObject {
    
    func showAlert(
        title: String?,
        message: String?,
        okButton: String,
        action: (()-> Void)?
    )
}

extension AlertPresentable where Self: UIViewController {
    
    func showAlert(
        title: String?,
        message: String?,
        okButton: String,
        action: (()-> Void)?
    ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: okButton, style: .cancel) { _ in
            action?()
        }
        alert.addAction(okButton)
        present(alert, animated: true)
    }
}
