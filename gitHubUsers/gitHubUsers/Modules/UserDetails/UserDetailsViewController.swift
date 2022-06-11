//
//  UserDetailsViewController.swift
//  gitHubUsers
//
//  Created by Veronika Goreva on 09.05.2022.
//

import Foundation
import UIKit

protocol IUserDetailsView: AlertPresentable {
    
    func dismiss()
    func configure(with model: ViewMode<UserDetailViewModel>)
}

final class UserDetailsViewController: UIViewController {
    
    // Dependencies
    private let output: IUserDetailsViewModel
    
    // UI
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    private lazy var userDetailView = UserDetailView()
    
    // MARK: - Init
    
    init(
        output: IUserDetailsViewModel
    ) {
        self.output = output
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigation()
        output.viewIsReady()
    }
    
    // MARK: - Private
    
    private func setupUI() {
        view.backgroundColor = Colors.secondaryBackgroundColor
        view.addSubview(scrollView)
        scrollView.addSubview(userDetailView)
        NSLayoutConstraint.activate(
            [scrollView.topAnchor.constraint(equalTo: view.topAnchor),
             scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
             scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
             scrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
             scrollView.widthAnchor.constraint(equalTo: userDetailView.widthAnchor)
            ]
        )
        userDetailView.translatesAutoresizingMaskIntoConstraints = false
        userDetailView.edgesToSuperview()
    }
    
    private func setupNavigation() {
        let leftButton = UIBarButtonItem(
            title: "Close",
            style: .plain,
            target: self,
            action: #selector(closeAction)
        )
        navigationItem.leftBarButtonItem = leftButton
    }
      
    @objc
    private func closeAction() {
        dismiss(animated: true)
    }
}

// MARK: - IUserDetailsView

extension UserDetailsViewController: IUserDetailsView {
    
    func configure(with model: ViewMode<UserDetailViewModel>) {
        userDetailView.configure(with: model)
    }
    
    func dismiss() {
        dismiss(animated: true)
    }
}
