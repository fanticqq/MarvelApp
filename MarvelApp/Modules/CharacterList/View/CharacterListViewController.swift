//
//  CharacterListViewController.swift
//  MarvelApp
//
//  Created by Igor Zarubin on 26.03.2022.
//

import UIKit
import Combine

enum CharacterListSection {
    case main
}

final class CharacterListViewController: UIViewController {
    private let viewModel: CharacterListViewModel
    private var subscriptions = Set<AnyCancellable>()

    private lazy var adapter = CharactersListAdapter(collectionView: self.collectionView)

    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: self.makeLayout())
        view.backgroundColor = Asset.Colors.base.color
        view.contentInset = UIEdgeInsets(top: ViewSpecs.sideOffset, left: 0, bottom: 0, right: 0)
        return view.forAutoLayout()
    }()

    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = Asset.Colors.accent.color
        indicator.hidesWhenStopped = true
        return indicator.forAutoLayout()
    }()
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        return searchController
    }()

    private lazy var loadingFailedView = CharactersListLoadingFailedView().forAutoLayout()

    init(viewModel: CharacterListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Asset.Colors.base.color
        self.configure()
        self.viewModel.loadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.definesPresentationContext = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.definesPresentationContext = true
    }
}

extension CharacterListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        self.viewModel.searchCharacters(by: searchController.searchBar.text ?? "")
    }
}

private extension CharacterListViewController {
    func configure() {
        self.configureUI()
        self.configureSubscriptions()
        self.configureLayout()
    }

    func configureUI() {
        self.configureSearchUI()
        
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.navigationItem.searchController = searchController
        self.view.addSubview(self.collectionView)
        self.view.addSubview(self.loadingIndicator)
        self.view.addSubview(self.loadingFailedView)
    }
    
    func configureSearchUI() {
        let searchBar = self.searchController.searchBar
        searchBar.tintColor = Asset.Colors.accent.color
        searchBar.searchBarStyle = .minimal
        searchBar.searchTextField.leftView?.tintColor = Asset.Colors.accent.color
        searchBar.searchTextField.textColor = Asset.Colors.textPrimary.color
        searchBar.placeholder = L10n.AvengerList.Search.hint
        
        self.searchController.searchResultsUpdater = self
        self.searchController.obscuresBackgroundDuringPresentation = false
    }

    func configureLayout() {
        NSLayoutConstraint.activate([
            self.collectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.collectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.collectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            self.collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        NSLayoutConstraint.activate([
            self.loadingIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.loadingIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
        NSLayoutConstraint.activate([
            self.loadingFailedView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.loadingFailedView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
    }

    func configureSubscriptions() {
        self.viewModel.$displayItems
            .receive(on: DispatchQueue.main)
            .sink { [weak self] items in
                self?.adapter.updateData(with: items)
            }
            .store(in: &self.subscriptions)

        self.viewModel.$loadingState
            .receive(on: DispatchQueue.main)
            .map { loadingState in
                loadingState != .initialLoading
            }
            .sink { [weak self] indicatorHidden in
                if indicatorHidden {
                    self?.loadingIndicator.stopAnimating()
                } else {
                    self?.loadingIndicator.startAnimating()
                }
            }
            .store(in: &self.subscriptions)

        self.viewModel.$loadingState
            .receive(on: DispatchQueue.main)
            .map { loadingState in
                loadingState != .initialLoadingFailed
            }
            .sink { [weak self] loadingFailedViewHidden in
                self?.loadingFailedView.isHidden = loadingFailedViewHidden
            }
            .store(in: &self.subscriptions)

        self.viewModel.$loadingState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                switch state {
                case .partialLoading:
                    self?.adapter.footer = .loader
                case .partialLoadingFailed:
                    self?.adapter.footer = .loadingFailure
                default:
                    self?.adapter.footer = .empty
                }
            }
            .store(in: &self.subscriptions)

        self.adapter.onLoadNextPage = { [weak self] in
            self?.viewModel.loadNextPage()
        }
        self.adapter.onRetry = { [weak self] in
            self?.viewModel.retry()
        }
        self.loadingFailedView.onRefreshPressed = { [weak self] in
            self?.viewModel.retry()
        }
    }
}

extension CharacterListViewController {
    func makeLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(
            top: 0,
            leading: ViewSpecs.sideOffset,
            bottom: 0,
            trailing: ViewSpecs.sideOffset
        )
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(64)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8

        let footerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(100.0)
        )
        let footer = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: footerSize,
            elementKind: UICollectionView.elementKindSectionFooter,
            alignment: .bottom
        )
        section.boundarySupplementaryItems = [footer]

        return UICollectionViewCompositionalLayout(section: section)
    }
}
