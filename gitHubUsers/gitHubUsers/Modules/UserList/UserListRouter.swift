//
//  UserListRouter.swift
//  gitHubUsers
//
//  Created by Veronika Goreva on 22.05.2022.
//

import UIKit

protocol IUserListRouter: AnyObject {

    func showUserDetails(with username: String)
}

final class UserListRouter: IUserListRouter {
    
    // Dependencies
    private let userService: IApiUserService
    private let imageProvider: ImageProvider
    weak var transitionHandeler: UIViewController?
    
    init(
        userService: IApiUserService,
        imageProvider: ImageProvider
    ) {
        self.userService = userService
        self.imageProvider = imageProvider
    }
    // MARK: - IUserListRouter
    
    func showUserDetails(with username: String) {
        let viewModel = UserDetailsViewModel(
            username: username,
            userService: userService,
            imageProvider: imageProvider
        )
        let viewController = UserDetailsViewController(output: viewModel)
        viewModel.view = viewController
        let navigationController = UINavigationController(rootViewController: viewController)
        transitionHandeler?.present(navigationController, animated: true)
    }
}
