//
//  UserDetailView.swift
//  gitHubUsers
//
//  Created by Veronika Goreva on 10.05.2022.
//

import UIKit

struct UserDetailViewModel {
    
    let avatar: URL?
    let imageProvider: ImageProvider?
    let name: String
    let bio: String?
    let company: NSAttributedString?
    let email: NSAttributedString?
    let followers: NSAttributedString?
}

private enum Constants {
    static let avatarSize: CGFloat = 200
    static let skeletonLineHeight: CGFloat = 15
}
final class UserDetailView: UIView {
    
    // UI
    private lazy var avatarImageView = UserAvatarImageView()
    private lazy var detalsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = CGFloat.smallMargin
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    private lazy var detailsSkeletonView = MultilineSkeletonView(
        views: [(height: Constants.skeletonLineHeight, width: 250),
                (height: Constants.skeletonLineHeight, width: nil),
                (height: Constants.skeletonLineHeight, width: 280),
                (height: Constants.skeletonLineHeight, width: 150)]
    )
    // MARK: - Init
    
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private

    private func setupUI() {
        addSubview(avatarImageView)
        addSubview(detalsStackView)
        addSubview(detailsSkeletonView)
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [
                avatarImageView.widthAnchor.constraint(equalToConstant: Constants.avatarSize),
                avatarImageView.heightAnchor.constraint(equalToConstant: Constants.avatarSize),
                avatarImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
                avatarImageView.topAnchor.constraint(equalTo: topAnchor, constant: 100)
            ]
        )
        
        NSLayoutConstraint.activate(
            [
                detalsStackView.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: CGFloat.extraMargin),
                detalsStackView.leftAnchor.constraint(equalTo: leftAnchor, constant: CGFloat.extraMargin),
                detalsStackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -CGFloat.extraMargin),
                detalsStackView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -CGFloat.baseMargin)
            ]
        )
        
        detailsSkeletonView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [
                detailsSkeletonView.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: CGFloat.extraMargin),
                detailsSkeletonView.leftAnchor.constraint(equalTo: leftAnchor, constant: CGFloat.extraMargin),
                detailsSkeletonView.rightAnchor.constraint(equalTo: rightAnchor, constant: -CGFloat.extraMargin),
                detailsSkeletonView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -CGFloat.baseMargin)
                
            ]
        )
        detailsSkeletonView.isHidden = true
    }

    private func showSkeleton() {
        avatarImageView.showSkeleton()
        detailsSkeletonView.isHidden = false
        detailsSkeletonView.startAnimation()
    }
    
    private func hideSkeleton() {
        avatarImageView.hideSkeleton()
        detailsSkeletonView.isHidden = true
        detailsSkeletonView.stopAnimation()
    }
    
    private func addDetails(_ model: UserDetailViewModel) {
        let nameLabel = obtainLabel()
        nameLabel.text = model.name
        detalsStackView.addArrangedSubview(nameLabel)
        if let follwers = model.followers {
            addAttributedLabel(with: follwers)
        }
        if let company = model.company {
            addAttributedLabel(with: company)
        }
        if let email = model.email {
            addAttributedLabel(with: email)
        }
        
        if let bio = model.bio {
            let label = obtainLabel(
                font: UIFont.italicSystemFont(ofSize: 15.0),
                textColor: Colors.secondaryTextColor
            )
            label.text = bio
            detalsStackView.addArrangedSubview(label)
        }
    }
    
    private func addAttributedLabel(with text: NSAttributedString) {
        let label = obtainLabel()
        label.attributedText = text
        detalsStackView.addArrangedSubview(label)
    }
    
    private func obtainLabel(
        font: UIFont = UIFont.boldSystemFont(ofSize: 20.0),
        textColor: UIColor = Colors.primaryTextColor
    ) -> UILabel {
        let label = CopyableLabel()
        label.numberOfLines = 0
        label.font = font
        label.textColor = textColor
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
}

// MARK: - ConfigurableView

extension UserDetailView: ConfigurableView {
    
    func configure(with mode: ViewMode<UserDetailViewModel>) {
        switch mode {
        case .content(let model):
            hideSkeleton()
            avatarImageView.setImage(
                by: model.avatar,
                imageProvider: model.imageProvider
            )
            addDetails(model)
        case .skeleton:
            showSkeleton()
        }
    }
}
