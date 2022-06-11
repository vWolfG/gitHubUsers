//
//  ContainerTableViewCell.swift
//  gitHubUsers
//
//  Created by Veronika Goreva on 08.05.2022.
//

import Foundation
import UIKit

protocol ConfigurableView: AnyObject {
    
    associatedtype Model
    func configure(with model: Model)
}

protocol PreparableForReuse: AnyObject {
    
    func prepareForReuse()
}

final class ContainerTableViewCell<Cell: UIView>: UITableViewCell, ConfigurableView where Cell: ConfigurableView, Cell: PreparableForReuse {
    
    // UI
    let containerView: Cell
    
    // Properties
    private lazy var containerViewConstraints = [
        containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: insets.top),
        containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -insets.bottom),
        containerView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: insets.left),
        containerView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -insets.right)
    ]
    var insets: UIEdgeInsets = UIEdgeInsets(
        top: CGFloat.baseMargin,
        left: CGFloat.baseMargin,
        bottom: CGFloat.baseMargin,
        right: CGFloat.baseMargin
    ) {
        didSet {
            remakeConstraints()
        }
    }

    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        containerView = Cell()
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        containerView.prepareForReuse()
    }

    // MARK: - Private

    private func setup() {
        backgroundColor = .clear
        contentView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(containerViewConstraints)
    }

    private func remakeConstraints() {
        containerViewConstraints.forEach { constraint in
            switch constraint.firstAnchor {
            case containerView.topAnchor:
                constraint.constant = insets.top
            case containerView.bottomAnchor:
                constraint.constant = -insets.bottom
            case containerView.leftAnchor:
                constraint.constant = insets.left
            case containerView.rightAnchor:
                constraint.constant = -insets.right
            default:
                break
            }
            
        }
    }
    
    // MARK: - ConfigurableView
    
    func configure(with model: Cell.Model) {
        containerView.configure(with: model)
    }
}
