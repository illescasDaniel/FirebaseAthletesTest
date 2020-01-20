//
//  ViewController.swift
//  FirebaseAthletesTest
//
//  Created by Daniel Illescas Romero on 20/01/2020.
//  Copyright © 2020 Daniel Illescas Romero. All rights reserved.
//

import UIKit

class UsersAndTeamsViewController: UIViewController {
	
	// MARK: - Views
	
	lazy var viewModel = UsersAndTeamsViewModel()
	
	lazy var userCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).apply {
		$0.backgroundColor = .systemGroupedBackground
		$0.register(
			UINib(nibName: "\(UserCollectionViewCell.self)", bundle: .main),
			forCellWithReuseIdentifier: "\(UserCollectionViewCell.self)"
		)
		$0.dataSource = self.viewModel.usersDataSource
		$0.delegate = self
		$0.backgroundView = self.activityIndicator
		$0.addSubview(self.refreshIndicator)
	}
	
	lazy var teamsTableView = UITableView(frame: .zero, style: .plain).apply {
		$0.backgroundColor = .systemGroupedBackground
		$0.isHidden = true
	}
	
	lazy var searchController = UISearchController(searchResultsController: nil).apply {
		$0.obscuresBackgroundDuringPresentation = false
		$0.searchResultsUpdater = self.viewModel
		$0.searchBar.scopeButtonTitles = ["Athlets", "Teams"]
		$0.searchBar.selectedScopeButtonIndex = 0
		$0.searchBar.showsScopeBar = true
		$0.searchBar.delegate = self
	}
	
	lazy var activityIndicator: UIActivityIndicatorView? = UIActivityIndicatorView(style: .medium)
	
	lazy var refreshIndicator = UIRefreshControl().apply {
		$0.addTarget(self, action: #selector(self.pulledToRefresh), for: .valueChanged)
	}
	
	// MARK: Properties
	
	var tabs: [String] {[
		"Athletes", "Teams"
	]}
	
	
	// MARK: - Life cycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.setupViews()
		self.setupUserListStateObserver()
		self.viewModel.fetchUsers()
	}
	
	// MARK: - Actions
	
	@objc private func pulledToRefresh() {
		self.viewModel.fetchUsers()
	}
	
	// MARK: - Convenience
	
	private func setupUserListStateObserver() {
		self.viewModel.userListStateObserver = { [weak self] state in
			guard let self = self else { return }
			switch state {
			case .idle:
				break
			case .loading:
				self.activityIndicator?.startAnimating()
				if self.activityIndicator == nil {
					self.refreshIndicator.beginRefreshing()
				}
			case .loaded:
				self.activityIndicator?.stopAnimating()
				self.activityIndicator = nil
				self.refreshIndicator.endRefreshing()
				self.userCollectionView.backgroundView?.isHidden = true
				self.userCollectionView.reloadData()
			case .performedSearch(let emptyResult):
				if emptyResult {
					if self.userCollectionView.backgroundView == self.activityIndicator {
						let emptyStateLabel = UILabel()
						emptyStateLabel.text = "No results"
						emptyStateLabel.textAlignment = .center
						self.userCollectionView.backgroundView = emptyStateLabel
					}
				} else {
					self.userCollectionView.backgroundView?.isHidden = true
				}
				self.userCollectionView.reloadData()
			}
		}
	}
	
	private func setupViews() {
		
		self.view.addSubview(self.userCollectionView)
		self.userCollectionView.snapToParent(self.view)
		
		self.view.addSubview(self.teamsTableView)
		self.teamsTableView.snapToParent(self.view)
		
		self.title = tabs.first
		self.navigationItem.searchController = self.searchController
		self.definesPresentationContext = true
	}
}

// MARK: - UISearchBarDelegate
extension UsersAndTeamsViewController: UISearchBarDelegate {
	func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
		self.title = tabs[selectedScope]
		self.teamsTableView.isHidden = selectedScope == 0
		self.userCollectionView.isHidden = selectedScope != 0
	}
}

// MARK: - UICollectionViewDelegateFlowLayout
extension UsersAndTeamsViewController: UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: self.view.bounds.width, height: 100)
	}
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		return 0
	}
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return 0
	}
}
