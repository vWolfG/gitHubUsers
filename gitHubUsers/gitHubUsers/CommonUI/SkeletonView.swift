//
//  SkeletonView.swift
//  gitHubUsers
//
//  Created by Veronika Goreva on 21.05.2022.
//

import UIKit

private extension String {

    static let animationKey = "skeleton_gradien_github_animation"
}

final class SkeletonView: UIView {
    
    private lazy var gradientLayer: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.locations = [0.0, 0.0, 0.25]
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        gradient.anchorPoint = .zero
        return gradient
    }()
    
    private lazy var animation: CAAnimation = {
        let gradientAnimation = CABasicAnimation(keyPath: "locations")
        gradientAnimation.fromValue = [0.0, 0.0, 0.25]
        gradientAnimation.toValue = [0.75, 1.0, 1.0]
        gradientAnimation.duration = 2
        gradientAnimation.repeatCount = 1
        return gradientAnimation
    }()
    private var animationShouldStop = false
    private var isAnimating: Bool = false
    
    // MARK: - Init
    
    init() {
        super.init(frame: .zero)
        setupUI()
        updateColors()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateColors()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = CGRect(
            x: -bounds.width,
            y: bounds.origin.y,
            width: 3 * bounds.width,
            height: bounds.height
        )
    }
    private func setupUI() {
        clipsToBounds = true
        layer.addSublayer(gradientLayer)
    }
    
    private func updateColors() {
        gradientLayer.colors = [
            Colors.primarySkeleton.cgColor,
            Colors.secondarySkeleton.cgColor,
            Colors.primarySkeleton.cgColor
        ]
    }
    
    func startAnimation() {
        guard !isAnimating else { return }
        isAnimating = true
        animation.delegate = self
        animationShouldStop = false
        gradientLayer.add(animation, forKey: .animationKey)
    }
    
    func stopAnimation() {
        animationShouldStop = true
    }
    
    func clearAnimtion() {
        animation.delegate = nil
        isAnimating = false
    }
}

// MARK: - CAAnimationDelegate

extension SkeletonView: CAAnimationDelegate {
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        guard !animationShouldStop, superview != nil else {
            clearAnimtion()
            return
        }
        gradientLayer.add(animation, forKey: .animationKey)
    }
}
