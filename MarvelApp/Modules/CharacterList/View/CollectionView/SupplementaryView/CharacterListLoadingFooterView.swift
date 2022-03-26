//
//  CharacterListLoadingFooterView.swift
//  MarvelApp
//
//  Created by Igor Zarubin on 26.03.2022.
//

import UIKit

final class CharacterListLoadingFooterView: UICollectionReusableView {
    private let activityIndicator = UIActivityIndicatorView(style: .large).forAutoLayout()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension CharacterListLoadingFooterView {
    func configureUI() {
        self.activityIndicator.color = Asset.Colors.accent.color
        self.activityIndicator.startAnimating()
        self.addSubview(self.activityIndicator)
        NSLayoutConstraint.activate([
            self.activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
}
