//
//  CharactersListPlaceholderView.swift
//  MarvelApp
//
//  Created by Igor Zarubin on 26.03.2022.
//

import UIKit

final class CharactersListPlaceholderView: UIView {
    var onActionTriggered: (() -> Void)?

    private lazy var titleLabel: UILabel = self.makeTitleLabel()
    private lazy var descriptionLabel: UILabel = self.makeDescriptionLabel()
    private lazy var actionButton: UIButton = self.makeActionButton()
    private let stackView = UIStackView().forAutoLayout()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureUI()
        self.configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with placeholder: CharactersListPlaceholder) {
        self.titleLabel.text = placeholder.title
        self.descriptionLabel.text = placeholder.description
        if let action = placeholder.action {
            self.actionButton.setTitle(action, for: .normal)
            self.actionButton.isHidden = false
        } else {
            self.actionButton.isHidden = true            
        }
    }
}

private extension CharactersListPlaceholderView {
    func configureUI() {
        self.backgroundColor = Asset.Colors.base.color
        self.stackView.axis = .vertical
        self.stackView.addArrangedSubview(self.titleLabel)
        self.stackView.setCustomSpacing(20, after: self.titleLabel)
        self.stackView.addArrangedSubview(self.descriptionLabel)
        self.stackView.setCustomSpacing(40, after: self.descriptionLabel)
        self.stackView.addArrangedSubview(self.actionButton)
        self.addSubview(self.stackView)
    }

    func configureLayout() {
        NSLayoutConstraint.activate([
            self.stackView.topAnchor.constraint(equalTo: self.topAnchor),
            self.stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.stackView.leadingAnchor.constraint(
                greaterThanOrEqualTo: self.leadingAnchor,
                constant: ViewSpecs.sideOffset
            ),
            self.stackView.trailingAnchor.constraint(
                lessThanOrEqualTo: self.trailingAnchor,
                constant: -ViewSpecs.sideOffset
            )
        ])
    }

    @objc func actionButtonPressed() {
        self.onActionTriggered?()
    }
}

extension CharactersListPlaceholderView {
    func makeTitleLabel() -> UILabel {
        let label = UILabel()
        label.textColor = Asset.Colors.accent.color
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 25)
        return label.forAutoLayout()
    }

    func makeDescriptionLabel() -> UILabel {
        let label = UILabel()
        label.textColor = Asset.Colors.accent.color
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 17, weight: .regular)
        return label.forAutoLayout()
    }

    func makeActionButton() -> UIButton {
        let button = UIButton(type: .system)
        button.tintColor = Asset.Colors.accent.color
        button.layer.borderColor = Asset.Colors.accent.color.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = ViewSpecs.innerOffset
        button.contentEdgeInsets = UIEdgeInsets(
            top: ViewSpecs.innerOffset,
            left: ViewSpecs.innerOffset,
            bottom: ViewSpecs.innerOffset,
            right: ViewSpecs.innerOffset
        )
        button.addTarget(self, action: #selector(actionButtonPressed), for: .touchUpInside)
        return button.forAutoLayout()
    }
}
