//
//  AppDelegate.swift
//  gitHubUsers
//
//  Created by Veronika Goreva on 08.05.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow()
        window?.makeKeyAndVisible()
        let navController = UINavigationController(rootViewController: buildMainModule())
        window?.rootViewController = navController
        return true
    }
    
    func buildMainModule() -> UIViewController {
        let usersService = ApiUsersService(
            requestProcessor: RequestProcessor(
                urlRequestBuilder: URLRequestBuilder()
            )
        )
        let imageService = ImageService(
            imageCache: MemoryCache<Data>(maxSize: 10 * 1024 * 1024).typeErased()
        )
        let debouncer = Debouncer(timeInterval: .milliseconds(3))
        let listRouter = UserListRouter(
            userService: usersService,
            imageProvider: imageService
        )
        let viewModel = UserListViewModel(
            router: listRouter,
            debouncer: debouncer,
            usersService: usersService,
            imageProvider: imageService
        )
        let viewController = UserListViewController(output: viewModel)
        viewModel.view = viewController
        listRouter.transitionHandeler = viewController
        return viewController
    }
}
