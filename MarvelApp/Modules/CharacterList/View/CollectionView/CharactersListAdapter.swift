//
//  CharactersListAdapter.swift
//  MarvelApp
//
//  Created by Igor Zarubin on 26.03.2022.
//

import UIKit
import Combine

final class CharactersListAdapter: NSObject {
    typealias DataSource = UICollectionViewDiffableDataSource<CharacterListSection, CharacterCellDisplayItem>

    var onLoadNextPage: (() -> Void)?
    var onRetry: (() -> Void)?
    var onSelectItemAtIndexPath: ((IndexPath) -> Void)?

    var footer: Footer = .empty {
        didSet {
            guard oldValue != footer else {
                return
            }
            self.updateFooter()
        }
    }

    private var prefetchContentOffset: CGFloat {
        collectionView.bounds.height / 2
    }
    private let collectionView: UICollectionView

    private lazy var dataSource = self.makeDataSource()

    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
        super.init()
        self.collectionView.delegate = self
        self.collectionView.register(cellClass: CharacterCell.self)
        self.collectionView.register(
            supplementaryClass: CharacterListLoadingFooterView.self,
            for: UICollectionView.elementKindSectionFooter
        )
        self.collectionView.register(
            supplementaryClass: CharacterListLoadingFailedFooterView.self,
            for: UICollectionView.elementKindSectionFooter
        )
        self.collectionView.register(
            supplementaryClass: EmptyCollectionReusableView.self,
            for: UICollectionView.elementKindSectionFooter
        )
    }

    func updateData(with dispayItems: [CharacterCellDisplayItem]) {
        var snapshot = NSDiffableDataSourceSnapshot<CharacterListSection, CharacterCellDisplayItem>()
        snapshot.appendSections([.main])
        snapshot.appendItems(dispayItems)
        self.dataSource.apply(snapshot)
    }
}

extension CharactersListAdapter: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard self.collectionView.numberOfItems(inSection: 0) > 0 else {
            return
        }
        let contentOffset = scrollView.contentOffset.y + scrollView.bounds.height
        let contentHeight = scrollView.contentSize.height
        guard contentHeight - contentOffset <= self.prefetchContentOffset else {
            return
        }
        self.onLoadNextPage?()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.onSelectItemAtIndexPath?(indexPath)
    }
}

extension CharactersListAdapter {
    enum Footer {
        case loader
        case loadingFailure
        case empty
    }
}

private extension CharactersListAdapter {
    func updateFooter() {
        var snapshot = self.dataSource.snapshot()
        snapshot.reloadSections([.main])
        self.dataSource.apply(snapshot, animatingDifferences: false)
    }

    func makeDataSource() -> DataSource {
        let dataSource = DataSource(
            collectionView: self.collectionView,
            cellProvider: { collectionView, indexPath, item in
                let cell: CharacterCell = collectionView.dequeueReusableCell(for: indexPath)
                cell.configure(with: item)
                return cell
            }
        )
        dataSource.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            guard let self = self else {
                return nil
            }

            switch self.footer {
            case .empty:
                let emptyView: EmptyCollectionReusableView = collectionView.dequeueSupplementaryView(
                    of: kind,
                    for: indexPath
                )
                return emptyView
            case .loader:
                let loaderView: CharacterListLoadingFooterView = collectionView.dequeueSupplementaryView(
                    of: kind,
                    for: indexPath
                )
                return loaderView
            case .loadingFailure:
                let failureView: CharacterListLoadingFailedFooterView = collectionView.dequeueSupplementaryView(
                    of: kind,
                    for: indexPath
                )
                failureView.onRefreshPressed = { [weak self] in
                    self?.onRetry?()
                }
                return failureView
            }
        }
        return dataSource
    }
}
