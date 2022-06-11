//
//  UserAvatarImageView.swift
//  gitHubUsers
//
//  Created by Veronika Goreva on 08.05.2022.
//

import Foundation
import UIKit

final class UserAvatarImageView: UIView {
    
    // UI
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private lazy var skeletonView = SkeletonView()
    
    // Properties
    private var imageLoadingTask: Cancellable?
    
    // MARK: - Init

    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
    }
    
    private func setup() {
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
        addSubview(skeletonView)
        imageView.edgesToSuperview()
        skeletonView.edgesToSuperview()
        skeletonView.isHidden = true
    }
    
    func setImage(by url: URL?, imageProvider: ImageProvider?) {
        imageView.image = nil
        imageLoadingTask?.cancel()
        imageLoadingTask = imageProvider?.image(
            from: url,
            completion: { [weak self] image in
                guard let self = self else { return }
                self.imageView.image = image
            }
        )
    }
    
    func showSkeleton() {
        imageView.isHidden = true
        skeletonView.isHidden = false
        skeletonView.startAnimation()
    }

    func hideSkeleton() {
        skeletonView.isHidden = true
        imageView.isHidden = false
        skeletonView.stopAnimation()
    }
}

// MARK: - PreparableForReuse

extension UserAvatarImageView: PreparableForReuse {

    func prepareForReuse() {
        imageLoadingTask?.cancel()
        imageView.image = nil
    }
}
