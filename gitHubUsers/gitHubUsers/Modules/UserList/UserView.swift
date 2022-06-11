//
//  UserView.swift
//  gitHubUsers
//
//  Created by Veronika Goreva on 08.05.2022.
//

import UIKit

enum ViewMode<Model> {
    case skeleton
    case content(Model)
}

struct UserViewModel {
    let image: URL?
    let imageProvider: ImageProvider
    let title: String
}

typealias UserViewCell = ContainerTableViewCell<UserView>

final class UserView: UIView {
    
    // UI
    private lazy var skeletonView: SkeletonView = {
        let view = SkeletonView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = CGFloat.mediumRadius
        return view
    }()
    private lazy var contentView = UIView()
    private lazy var avatarImageView = UserAvatarImageView()
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 15.0)
        label.textColor = Colors.primaryTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Init
    
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateShadowPath()
    }

    // MARK: - Private

    private func setupUI() {
        contentView.setupDefaultShadow()
        contentView.layer.cornerRadius = CGFloat.mediumRadius
        addSubview(contentView)
        addSubview(skeletonView)
        contentView.edgesToSuperview()
        skeletonView.edgesToSuperview()
        contentView.backgroundColor = Colors.secondaryBackgroundColor
        contentView.addSubview(avatarImageView)
        
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: topAnchor, constant: CGFloat.baseMargin),
            avatarImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: CGFloat.baseMargin),
            avatarImageView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -CGFloat.baseMargin),
            avatarImageView.heightAnchor.constraint(equalToConstant: CGFloat.mediumSize),
            avatarImageView.widthAnchor.constraint(equalToConstant: CGFloat.mediumSize)
        ])
        
        let contentTextStackView = UIStackView()
        contentTextStackView.translatesAutoresizingMaskIntoConstraints = false
        contentTextStackView.axis = .vertical
        contentTextStackView.spacing = CGFloat.smallMargin
        contentTextStackView.addArrangedSubview(titleLabel)
        
        contentView.addSubview(contentTextStackView)
        
        NSLayoutConstraint.activate([
            contentTextStackView.topAnchor.constraint(equalTo: topAnchor, constant: CGFloat.baseMargin),
            contentTextStackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -CGFloat.baseMargin),
            contentTextStackView.leftAnchor.constraint(equalTo: avatarImageView.rightAnchor, constant: CGFloat.baseMargin),
            contentTextStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -CGFloat.baseMargin)
        ])
    }

    private func updateShadowPath() {
        contentView.layer.shadowPath = UIBezierPath(
            roundedRect: contentView.bounds,
            cornerRadius: contentView.layer.cornerRadius
        ).cgPath
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        animateViewPress(isPressed: true)
        super.touchesBegan(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        animateViewPress(isPressed: false)
        super.touchesEnded(touches, with: event)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        animateViewPress(isPressed: false)
        super.touchesCancelled(touches, with: event)
    }
    
    private func animateViewPress(isPressed: Bool) {
        let minScale = 0.95
        let newTransform = isPressed ? CATransform3DMakeScale(minScale, minScale, 1) : CATransform3DMakeScale(1, 1, 1)
        let duration = 0.1
        var delay = 0.0
        if let presentationLayer = layer.presentation() {
            let animationProgress: Double = Double(presentationLayer.transform.m11 - 0.95) / (1 - 0.95)
            delay = (animationProgress - minScale) > 0.0 && !isPressed ? duration : 0
        }
        UIView.animate(
            withDuration: duration,
            delay: delay,
            options: [.beginFromCurrentState, .curveLinear],
            animations: {
                self.layer.transform = newTransform
        }, completion: nil)
    }
}

// MARK: - ConfigurableView

extension UserView: ConfigurableView{
    
    func configure(with mode: ViewMode<UserViewModel>) {
        switch mode {
        case .content(let model):
            skeletonView.isHidden = true
            skeletonView.stopAnimation()
            contentView.isHidden = false
            titleLabel.text = model.title
            avatarImageView.setImage(by: model.image, imageProvider: model.imageProvider)
        case .skeleton:
            contentView.isHidden = true
            skeletonView.isHidden = false
            skeletonView.startAnimation()
        }
    }
}

// MARK: - PreparableForReuse

extension UserView: PreparableForReuse {
    
    func prepareForReuse() {
//        avatarImageView.prepareForReuse()
    }
}
