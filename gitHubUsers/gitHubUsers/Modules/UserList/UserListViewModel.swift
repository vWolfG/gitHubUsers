//
//  UserListViewModel.swift
//  gitHubUsers
//
//  Created by Veronika Goreva on 09.05.2022.
//

import Foundation

protocol IUserListViewModel: AnyObject {

    var numberOfRows: Int { get }
    func viewIsReady()
    func viewModelForItem(at index: Int) -> ViewMode<UserViewModel>?
    func didScrollToTheEnd()
    func search(_ text: String?)
    func didSelectItem(at index: Int)
}

enum UserListState {
    case loading
    case waitingToLoad(page: Int)
    case terminated
}

final class UserListViewModel: IUserListViewModel {
    
    // Dependencies
    private let router: IUserListRouter
    private let debouncer: IDebouncer
    private let usersService: IApiUsersService
    private let imageProvider: ImageProvider
    weak var view: IUserListView?

    // Properties
    private var page: Int = 0
    private lazy var state = UserListState.waitingToLoad(page: page)
    private var searchText: String?
    private var userListTask: Cancellable?
    private var rawModels = [UserApiModel]()
    private var models = [UserViewModel]()
    private let mainQueue: IDispatchQueue
    
    // Computed properties
    private var isSkeletonEnabled: Bool {
        switch state {
        case .terminated:
            return false
        case .loading, .waitingToLoad:
            return page == .zero
        }
    }
    var numberOfRows: Int {
        isSkeletonEnabled ? 10 : models.count
    }
    
    // MARK: - Init
    
    init(
        router: IUserListRouter,
        debouncer: IDebouncer,
        usersService: IApiUsersService,
        imageProvider: ImageProvider,
        mainQueue: IDispatchQueue = DispatchQueue.main
    ) {
        self.router = router
        self.debouncer = debouncer
        self.usersService = usersService
        self.imageProvider = imageProvider
        self.mainQueue = mainQueue
    }
    
    func viewIsReady() {
        loadUsers()
    }
    
    func didScrollToTheEnd() {
        guard !isSkeletonEnabled  else { return }
        loadUsers()
    }

    func viewModelForItem(at index: Int) -> ViewMode<UserViewModel>? {
        if isSkeletonEnabled {
            return .skeleton
        } else {
            guard index < models.count else { return nil }
            return .content(models[index]) 
        }
    }

    func search(_ text: String?) {
        let textToSearch = text?.nonBlankOrNil()
        guard searchText != textToSearch else { return }
        debouncer.debounce { [weak self] in
            self?.searchText = textToSearch
            self?.state = .waitingToLoad(page: 0)
            self?.loadUsers()
        }
    }

    func didSelectItem(at index: Int) {
        guard index < rawModels.count else { return }
        router.showUserDetails(with: rawModels[index].login)
    }

    private func loadUsers() {
        guard case let .waitingToLoad(page: page) = state else { return }
        self.page = page
        state = .loading
        if page > 0 {
            self.mainQueue.executeAsync {
                self.view?.footerLoadingView(isVisiable: true)
            }
        }
        if isSkeletonEnabled {
            self.mainQueue.executeAsync {
                self.view?.reloadData()
                self.view?.setScrollEnabled(isEnabled: false)
            }
        }
        userListTask?.cancel()
        userListTask = usersService.loadUsers(page: page, searchText: searchText) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let paginatedlist):
                 let new = paginatedlist.items.map { model in
                    UserViewModel(
                        image: URL(string: model.avatarUrl ?? ""),
                        imageProvider: self.imageProvider,
                        title: model.login
                    )
                }
                self.mainQueue.executeAsync {
                    if page == 0 {
                        self.rawModels.removeAll()
                        self.models.removeAll()
                    }
                    self.rawModels.append(contentsOf: paginatedlist.items)
                    self.models.append(contentsOf: new)
                    self.page += 1
                    self.state = paginatedlist.isLatPage
                    ? .terminated
                    : .waitingToLoad(page: self.page)
                    self.view?.reloadData()
                    self.view?.setScrollEnabled(isEnabled: true)
                }
            case .failure(let error):
                self.mainQueue.executeAsync {
                    self.state = .terminated
                    self.view?.reloadData()
                    self.view?.showAlert(
                        title: "Error",
                        message: error.localizedDescription,
                        okButton: "Ok",
                        action: nil
                    )
                }
            }
        }
    }
}
