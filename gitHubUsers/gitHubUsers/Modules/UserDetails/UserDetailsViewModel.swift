//
//  UserDetailsViewModel.swift
//  gitHubUsers
//
//  Created by Veronika Goreva on 22.05.2022.
//

import Foundation
import UIKit

protocol IUserDetailsViewModel: AnyObject {
    
    func viewIsReady()
}

final class UserDetailsViewModel {
    
    // Dependencies
    private let userService: IApiUserService
    private let imageProvider: ImageProvider
    weak var view: IUserDetailsView?
    
    // Properties
    private let username: String
    private let mainQueue: IDispatchQueue
    
    // MARK: - Init

    init(
        username: String,
        userService: IApiUserService,
        imageProvider: ImageProvider,
        mainQueue: IDispatchQueue = DispatchQueue.main
    ) {
        self.username = username
        self.userService = userService
        self.imageProvider = imageProvider
        self.mainQueue = mainQueue
    }
    
    private func loadUserInfo() {
        userService.loadUser(username: username) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let model):
                let model = self.obtainViewModel(from: model)
                self.mainQueue.executeAsync {
                    self.view?.configure(with: .content(model))
                }
            case .failure(let error):
                self.mainQueue.executeAsync {
                    self.view?.showAlert(
                        title: "Error",
                        message: error.localizedDescription,
                        okButton: "Ok",
                        action: { [weak self] in
                            self?.view?.dismiss()
                        }
                    )
                }
            }
        }
    }
    
    private func obtainViewModel(from apiModel: UserDetailsApiModel) -> UserDetailViewModel {
        let followersCount = apiModel.followers ?? .zero
        let followersStr: String? = followersCount > .zero ? "\(followersCount)" : nil
        return UserDetailViewModel(
            avatar: URL(string: apiModel.avatarUrl ?? ""),
            imageProvider: imageProvider,
            name: apiModel.name ?? "-",
            bio: apiModel.bio,
            company: obtainAttributedUserDetails(title: "Company: ", value: apiModel.company),
            email: obtainAttributedUserDetails(title: "Email: ", value: apiModel.email),
            followers: obtainAttributedUserDetails(title: "Followers • ", value: followersStr)
        )
    }
    
    private func obtainAttributedUserDetails(title: String, value: String?) -> NSAttributedString? {
        guard let secondaryText = value else { return nil }
        let mutableString = NSMutableAttributedString()
        mutableString.append(obtainPrimaryAttributed(title))
        mutableString.append(obtainSecondatyAttributed(secondaryText))
        return mutableString
    }
    
    private func obtainPrimaryAttributed(_ text: String) -> NSAttributedString {
        NSAttributedString(
            string: text,
            attributes: [
                NSAttributedString.Key.foregroundColor: Colors.secondaryTextColor,
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15.0)
            ]
        )
    }
    
    private func obtainSecondatyAttributed(_ text: String) -> NSAttributedString {
        NSAttributedString(
            string: text,
            attributes: [
                NSAttributedString.Key.foregroundColor: Colors.primaryTextColor,
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15.0)
            ]
        )
    }
}

// MARK: - IUserDetailsViewModel

extension UserDetailsViewModel: IUserDetailsViewModel {
    
    func viewIsReady() {
        view?.configure(with: .skeleton)
        loadUserInfo()
    }
}
