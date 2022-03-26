//
//  CharacterCell.swift
//  MarvelApp
//
//  Created by Igor Zarubin on 26.03.2022.
//

import UIKit

final class CharacterCell: UICollectionViewCell {
    private static let indicatorImage = UIImage(systemName: "chevron.right")?.withRenderingMode(.alwaysTemplate)

    private let avatarImageView = UIImageView().forAutoLayout()
    private let indicatorImageView = UIImageView().forAutoLayout()
    private let nameLabel = UILabel().forAutoLayout()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureUI()
        self.configureLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 16
    }

    func configure(with displayItem: CharacterCellDisplayItem) {
        self.nameLabel.text = displayItem.name
        self.avatarImageView.setImage(for: displayItem.imageURL, placeholder: nil)
    }
}

private extension CharacterCell {
    func configureUI() {
        self.backgroundColor = Asset.Colors.accent.color
        self.nameLabel.textColor = Asset.Colors.textPrimary.color
        self.nameLabel.font = UIFont.systemFont(ofSize: 13)
        self.indicatorImageView.image = CharacterCell.indicatorImage
        self.indicatorImageView.tintColor = Asset.Colors.textPrimary.color
        self.contentView.addSubview(self.nameLabel)
        self.contentView.addSubview(self.avatarImageView)
        self.contentView.addSubview(self.indicatorImageView)
    }

    func configureLayout() {
        NSLayoutConstraint.activate([
            self.avatarImageView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            self.avatarImageView.leadingAnchor.constraint(
                equalTo: self.contentView.leadingAnchor,
                constant: ViewSpecs.sideOffset
            ),
            self.avatarImageView.heightAnchor.constraint(equalToConstant: 44),
            self.avatarImageView.widthAnchor.constraint(equalToConstant: 44)
        ])
        NSLayoutConstraint.activate([
            self.nameLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            self.nameLabel.leadingAnchor.constraint(
                equalTo: self.avatarImageView.trailingAnchor,
                constant: ViewSpecs.innerOffset
            ),
            self.nameLabel.trailingAnchor.constraint(
                equalTo: self.indicatorImageView.leadingAnchor,
                constant: -ViewSpecs.innerOffset
            )
        ])
        let imageSize = CharacterCell.indicatorImage?.size ?? .zero
        NSLayoutConstraint.activate([
            self.indicatorImageView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            self.indicatorImageView.widthAnchor.constraint(equalToConstant: imageSize.width),
            self.indicatorImageView.heightAnchor.constraint(equalToConstant: imageSize.height),
            self.indicatorImageView.trailingAnchor.constraint(
                equalTo: self.contentView.trailingAnchor,
                constant: -ViewSpecs.sideOffset
            )
        ])
    }
}
