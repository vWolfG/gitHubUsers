//
//  MultilineSkeletonView.swift
//  gitHubUsers
//
//  Created by Veronika Goreva on 29.05.2022.
//

import UIKit

final class MultilineSkeletonView: UIView {
    
    // UI
    private var skeletons = [SkeletonView]()
    
    // MARK: - Init
    
    init(views: [(height: CGFloat, width: CGFloat?)]) {
        super.init(frame: .zero)
        setupUI(with: views)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private

    private func setupUI(with views: [(height: CGFloat, width: CGFloat?)]) {
        let contentStackView = UIStackView()
        contentStackView.axis = .vertical
        contentStackView.distribution = .fill
        contentStackView.alignment = .center
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.spacing = CGFloat.smallMargin
        addSubview(contentStackView)
        contentStackView.edgesToSuperview()
        views.forEach { (height, width) in
            let skeletonView = SkeletonView()
            skeletonView.translatesAutoresizingMaskIntoConstraints = false
            skeletonView.layer.cornerRadius = CGFloat.smallRadius
            contentStackView.addArrangedSubview(skeletonView)
            NSLayoutConstraint.activate([skeletonView.heightAnchor.constraint(equalToConstant: height)])
            if let width = width {
                NSLayoutConstraint.activate([skeletonView.widthAnchor.constraint(equalToConstant: width)])
            } else {
                NSLayoutConstraint.activate([skeletonView.widthAnchor.constraint(equalTo: contentStackView.widthAnchor)])
            }
            skeletons.append(skeletonView)
        }
    }
    
    func startAnimation() {
        skeletons.forEach { $0.startAnimation() }
    }
    
    func stopAnimation() {
        skeletons.forEach { $0.stopAnimation() }
    }
}
