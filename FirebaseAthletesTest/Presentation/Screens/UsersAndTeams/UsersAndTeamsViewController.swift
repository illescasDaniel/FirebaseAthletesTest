//
//  ViewController.swift
//  FirebaseAthletesTest
//
//  Created by Daniel Illescas Romero on 20/01/2020.
//  Copyright © 2020 Daniel Illescas Romero. All rights reserved.
//

import UIKit

class UsersAndTeamsViewController: UIViewController {
	
	// MARK: - IBOutlets
	
	@IBOutlet weak var usersTeamsSegmentedControl: UISegmentedControl!
	@IBOutlet weak var dataViewContainer: UIView!
	@IBOutlet weak var searchBar: UISearchBar!
	
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
		self.setupUserListStateObserver()
		self.setupViews()
		self.viewModel.fetchUsers()
	}
	
	// MARK: - Actions
	
	@objc private func pulledToRefresh() {
		self.viewModel.fetchUsers()
	}
	
	@IBAction func usersTeamsSegmentedControlChanged(_ sender: UISegmentedControl) {
		let index = sender.selectedSegmentIndex
		self.title = tabs[index]
		self.teamsTableView.isHidden = index == 0
		self.userCollectionView.isHidden = index != 0
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
					self.userCollectionView.backgroundView = SimpleEmptyStateLabel.create()
					self.userCollectionView.backgroundView?.isHidden = false
				} else {
					self.userCollectionView.backgroundView?.isHidden = true
				}
				self.userCollectionView.reloadData()
			}
		}
	}
	
	private func setupViews() {
		
		self.searchBar.placeholder = "Search"
		self.searchBar.delegate = self
		
		self.dataViewContainer.addSubview(self.userCollectionView)
		self.userCollectionView.snapToParent(self.dataViewContainer)
		
		self.dataViewContainer.addSubview(self.teamsTableView)
		self.teamsTableView.snapToParent(self.dataViewContainer)
		
		for (i, tab) in tabs.enumerated() {
			self.usersTeamsSegmentedControl.setTitle(tab, forSegmentAt: i)
		}
		self.usersTeamsSegmentedControl.selectedSegmentIndex = 0
		
		self.title = tabs.first
	}
}

// MARK: - UISearchBarControllerDelegate
extension UsersAndTeamsViewController: UISearchBarDelegate {
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		if searchText.isEmpty {
			self.view.endEditing(true)
		}
		self.viewModel.filterUsersList(withText: searchText)
	}
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		self.view.endEditing(true)
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
