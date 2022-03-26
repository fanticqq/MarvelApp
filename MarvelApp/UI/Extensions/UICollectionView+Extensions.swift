//
//  UICollectionView+Extensions.swift
//  MarvelApp
//
//  Created by Igor Zarubin on 26.03.2022.
//

import UIKit

extension UICollectionReusableView {
    static var reuseIdentifier: String { String(describing: self) }
}

extension UICollectionView {
    func register<T: UICollectionViewCell>(cellClass: T.Type) {
        self.register(cellClass, forCellWithReuseIdentifier: cellClass.reuseIdentifier)
    }

    func register<T: UICollectionReusableView>(supplementaryClass: T.Type, for kind: String) {
        self.register(
            supplementaryClass,
            forSupplementaryViewOfKind: kind,
            withReuseIdentifier: supplementaryClass.reuseIdentifier
        )
    }

    func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = self.dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Unknown cell type")
        }
        return cell
    }

    func dequeueSupplementaryView<T: UICollectionReusableView>(of kind: String, for indexPath: IndexPath) -> T {
        let view = self.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: T.reuseIdentifier,
            for: indexPath
        )
        guard let supplementaryView = view as? T else {
            fatalError("Unknown supplementaryView type")
        }
        return supplementaryView
    }
}
