//
//  CharactersListLoadingFailedView.swift
//  MarvelApp
//
//  Created by Igor Zarubin on 26.03.2022.
//

import UIKit

final class CharactersListLoadingFailedView: UICollectionReusableView {
    var onRefreshPressed: (() -> Void)?

    private lazy var titleLabel: UILabel = self.makeTitleLabel()
    private lazy var descriptionLabel: UILabel = self.makeDescriptionLabel()
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

private extension CharactersListLoadingFailedView {
    func configureUI() {
        self.backgroundColor = Asset.Colors.base.color
        self.stackView.axis = .vertical
        self.stackView.addArrangedSubview(self.titleLabel)
        self.stackView.setCustomSpacing(20, after: self.titleLabel)
        self.stackView.addArrangedSubview(self.descriptionLabel)
        self.stackView.setCustomSpacing(40, after: self.descriptionLabel)
        self.stackView.addArrangedSubview(self.tryAgainButton)
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

    @objc func tryAgainButtonPressed() {
        self.onRefreshPressed?()
    }
}

extension CharactersListLoadingFailedView {
    func makeTitleLabel() -> UILabel {
        let label = UILabel()
        label.text = L10n.AvengerList.InitialLoadingFailed.title
        label.textColor = Asset.Colors.accent.color
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 25)
        return label.forAutoLayout()
    }

    func makeDescriptionLabel() -> UILabel {
        let label = UILabel()
        label.text = L10n.AvengerList.InitialLoadingFailed.description
        label.textColor = Asset.Colors.accent.color
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 17, weight: .regular)
        return label.forAutoLayout()
    }

    func makeTryAgainButton() -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(L10n.AvengerList.LoadingFailed.action, for: .normal)
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
        return button.forAutoLayout()
    }
}
