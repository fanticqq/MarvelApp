//
//  CharacterListLoadingFailedFooterView.swift
//  MarvelApp
//
//  Created by Igor Zarubin on 26.03.2022.
//

import UIKit

final class CharacterListLoadingFailedFooterView: UICollectionReusableView {
    var onRefreshPressed: (() -> Void)?

    private lazy var titleLabel: UILabel = self.makeTitleLabel()
    private lazy var tryAgainButton: UIButton = self.makeTryAgainButton()
    private let stackView = UIStackView().forAutoLayout()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureUI()
        self.configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension CharacterListLoadingFailedFooterView {
    func configureUI() {
        self.backgroundColor = Asset.Colors.base.color
        self.stackView.spacing = ViewSpecs.innerOffset
        self.addSubview(self.stackView)
        self.stackView.addArrangedSubview(self.titleLabel)
        self.stackView.addArrangedSubview(self.tryAgainButton)
    }

    func configureLayout() {
        NSLayoutConstraint.activate([
            self.stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
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

    func makeTitleLabel() -> UILabel {
        let label = UILabel()
        label.text = L10n.LoadingFailed.text
        label.textColor = Asset.Colors.accent.color
        label.numberOfLines = 2
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        label.textAlignment = .center
        return label.forAutoLayout()
    }

    func makeTryAgainButton() -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(L10n.LoadingFailed.action, for: .normal)
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
        button.addTarget(self, action: #selector(tryAgainButtonPressed), for: .touchUpInside)
        button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        button.setContentCompressionResistancePriority(.required, for: .horizontal)
        return button.forAutoLayout()
    }

    @objc func tryAgainButtonPressed() {
        self.onRefreshPressed?()
    }
}
