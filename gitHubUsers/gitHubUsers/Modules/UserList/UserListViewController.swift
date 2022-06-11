//
//  UserListViewController.swift
//  gitHubUsers
//
//  Created by Veronika Goreva on 08.05.2022.
//

import Foundation
import UIKit

protocol IUserListView: AlertPresentable {
    
    func footerLoadingView(isVisiable: Bool)
    func reloadData()
    func setScrollEnabled(isEnabled: Bool)
}

final class UserListViewController: UIViewController {
    
    // UI
    let searchController = UISearchController()
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UserViewCell.self, forCellReuseIdentifier: userCellId)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.keyboardDismissMode = .interactive
        return tableView
    }()
    private lazy var emptyInfoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = Colors.secondaryTextColor
        label.numberOfLines = 0
        label.text = "Nothing found"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var activityIndicator = UIActivityIndicatorView(style: .large)
    private lazy var footerLoadingView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width:  tableView.bounds.width, height:  100))
        view.backgroundColor = .clear
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
             activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ]
        )
        
        return view
    }()
    
    // Properties
    private let userCellId = String(describing: UserViewCell.self)
    private let output: IUserListViewModel
    
    // MARK: - Init

    init(
        output: IUserListViewModel
    ) {
        self.output = output
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        output.viewIsReady()
    }
    
    // MARK: - Private
    
    private func setupUI() {
        view.backgroundColor = Colors.primaryBackgroundColor
        tableView.backgroundColor = .clear
        view.addSubview(tableView)
        NSLayoutConstraint.activate(
            [tableView.topAnchor.constraint(equalTo: view.topAnchor),
             tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
             tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
             tableView.rightAnchor.constraint(equalTo: view.rightAnchor)]
        )
        setupEmptyLabel()
        setupNavigation()
        observeKeyboard()
    }
    
    private func observeKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowNotification(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHideNotification(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func setupEmptyLabel() {
        view.addSubview(emptyInfoLabel)
        NSLayoutConstraint.activate(
            [emptyInfoLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
             emptyInfoLabel.leftAnchor.constraint(equalTo: view.leftAnchor),
             emptyInfoLabel.rightAnchor.constraint(equalTo: view.rightAnchor)]
        )
        setEmptyLabelVisiability(false)
    }
    
    private func setupNavigation() {
        title = "GitHubUsers"
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Type something here to search"
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func setEmptyLabelVisiability(_ isVisiable: Bool) {
        emptyInfoLabel.isHidden = !isVisiable
    }
    
    private func updateTebleViewBottomInset(with value: CGFloat) {
        tableView.contentInset.bottom = value
        tableView.verticalScrollIndicatorInsets.bottom = value
    }

    @objc
    private func keyboardWillShowNotification(_ notification: Notification) {
        let endKeyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue ?? .zero
        updateTebleViewBottomInset(with: endKeyboardFrame.size.height)
    }
    
    @objc
    private func keyboardWillHideNotification(_ notification: Notification) {
        updateTebleViewBottomInset(with: .zero)
    }
}

// MARK: - IUserListView

extension UserListViewController: IUserListView {

    func reloadData() {
        tableView.reloadData()
        footerLoadingView(isVisiable: false)
        setEmptyLabelVisiability(output.numberOfRows == 0)
    }
    
    func footerLoadingView(isVisiable: Bool) {
        if isVisiable {
            tableView.tableFooterView = footerLoadingView
            activityIndicator.startAnimating()
        } else if tableView.tableFooterView != nil {
            tableView.tableFooterView = nil
            activityIndicator.stopAnimating()
        }
    }
    
    func setScrollEnabled(isEnabled: Bool) {
        tableView.isScrollEnabled = isEnabled
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension UserListViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        output.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: userCellId, for: indexPath) as? UserViewCell,
              let model = output.viewModelForItem(at: indexPath.row) else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        cell.containerView.configure(with: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        output.didSelectItem(at: indexPath.row)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let bottomPosition = scrollView.contentOffset.y + scrollView.bounds.size.height
        if bottomPosition > scrollView.contentSize.height {
            output.didScrollToTheEnd()
        }
    }
}

// MARK: - UISearchBarDelegate

extension UserListViewController: UISearchBarDelegate, UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        output.search(searchController.searchBar.text)
    }
}
