//
//  ErrorView.swift
//  Challenge
//
//  Created by Zsolt Kovacs on 7/2/17.
//  Copyright © 2017 iOSmith. All rights reserved.
//

import UIKit

protocol ErrorViewDelegate: class {
    func retryButtonTapped()
}

class ErrorView: UIView {
    public var errorMessage: String? {
        didSet {
            errorLabel.text = errorMessage
            updateLayout()
        }
    }

    public weak var delegate: ErrorViewDelegate?

    private let errorLabel = UILabel()
    private let retryButton = UIButton(type: .system)
    private var heightConstraints: [NSLayoutConstraint] = []
    private var heightLimit: NSLayoutConstraint?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    private func setupView() {
        self.backgroundColor = UIColor.black

        errorLabel.textColor = UIColor.white
        errorLabel.font = UIFont.boldSystemFont(ofSize: 15)
        addSubview(errorLabel)

        retryButton.tintColor = UIColor.white
        retryButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        retryButton.setTitle(Strings.Root.retry, for: .normal)
        retryButton.addTarget(self, action: #selector(retryButtonTapped), for: .touchUpInside)
        addSubview(retryButton)

        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true

        retryButton.translatesAutoresizingMaskIntoConstraints = false
        retryButton.leadingAnchor.constraint(equalTo: errorLabel.trailingAnchor, constant: 20).isActive = true
        retryButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        retryButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true

        heightConstraints.append(errorLabel.topAnchor.constraint(equalTo: topAnchor, constant: 15))
        heightConstraints.append(errorLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15))

        heightLimit = heightAnchor.constraint(equalToConstant: 0)

        updateLayout()
    }

    private func updateLayout() {
        if errorMessage == nil {
            for constraint in heightConstraints {
                constraint.isActive = false
            }

            heightLimit?.isActive = true
        } else {
            heightLimit?.isActive = false

            for constraint in heightConstraints {
                constraint.isActive = true
            }
        }
    }

    @objc
    private func retryButtonTapped() {
        delegate?.retryButtonTapped()
    }
}
