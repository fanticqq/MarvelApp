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
        let layout = CharacterListLayoutBuilder.makeLayout()
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
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
        searchController.delegate = self
        return searchController
    }()

    private lazy var placeholderView = CharactersListPlaceholderView().forAutoLayout()

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

extension CharacterListViewController: UISearchResultsUpdating, UISearchControllerDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        self.viewModel.searchCharacters(by: searchController.searchBar.text ?? "")
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        self.viewModel.endSearch()
    }
}

private extension CharacterListViewController {
    func configure() {
        self.configureUI()
        self.configureSubscriptions()
        self.configureHandlers()
        self.configureLayout()
    }

    func configureUI() {
        self.configureSearchUI()
        
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.view.addSubview(self.collectionView)
        self.view.addSubview(self.loadingIndicator)
        self.view.addSubview(self.placeholderView)
    }
    
    func configureSearchUI() {
        let searchBar = self.searchController.searchBar
        searchBar.tintColor = Asset.Colors.accent.color
        searchBar.searchBarStyle = .minimal
        searchBar.barStyle = .black
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
            self.placeholderView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.placeholderView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
    }
    
    func configureHandlers() {
        self.adapter.onLoadNextPage = { [weak self] in
            self?.viewModel.loadNextPage()
        }
        self.adapter.onRetry = { [weak self] in
            self?.viewModel.retryNextPage()
        }
        self.placeholderView.onActionTriggered = { [weak self] in
            self?.viewModel.retry()
        }
        self.adapter.onSelectItemAtIndexPath = { [weak self] indexPath in
            self?.viewModel.select(characterAt: indexPath.item)            
        }
    }

    func configureSubscriptions() {
        let displayItems = self.viewModel.$displayItems.receive(on: DispatchQueue.main)
        
        displayItems
            .first(where: { !$0.isEmpty })
            .sink { [weak self] _ in
                self?.navigationItem.searchController = self?.searchController
            }
            .store(in: &self.subscriptions)
        
        displayItems
            .sink { [weak self] items in
                self?.adapter.updateData(with: items)
            }
            .store(in: &self.subscriptions)

        self.viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                if isLoading {
                    self?.collectionView.isHidden = true
                    self?.loadingIndicator.startAnimating()
                } else {
                    self?.collectionView.isHidden = false
                    self?.loadingIndicator.stopAnimating()
                }
            }
            .store(in: &self.subscriptions)

        self.viewModel.$placeholder
            .receive(on: DispatchQueue.main)
            .sink { [weak self] placeholder in
                if let placeholder = placeholder {
                    self?.placeholderView.configure(with: placeholder)
                    self?.placeholderView.isHidden = false
                    self?.collectionView.isHidden = true
                } else {
                    self?.placeholderView.isHidden = true
                    self?.collectionView.isHidden = false
                }
            }
            .store(in: &self.subscriptions)

        self.viewModel.$paginationState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                switch state {
                case .loadingNextPage:
                    self?.adapter.footer = .loader
                case .loadingNextPageFailed:
                    self?.adapter.footer = .loadingFailure
                case .none:
                    self?.adapter.footer = .empty
                }
            }
            .store(in: &self.subscriptions)
    }
}
