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
	
	@IBOutlet private weak var usersTeamsSegmentedControl: UISegmentedControl!
	@IBOutlet private weak var dataViewContainer: UIView!
	@IBOutlet private weak var searchBar: UISearchBar!
	
	// MARK: - Views
	
	lazy var viewModel = UsersAndTeamsViewModel()
	
	private lazy var userCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).apply {
		$0.backgroundColor = .systemGray6
		$0.register(
			UINib(nibName: "\(UserCollectionViewCell.self)", bundle: .main),
			forCellWithReuseIdentifier: "\(UserCollectionViewCell.self)"
		)
		$0.dataSource = self.viewModel.usersDataSource
		$0.delegate = self
		$0.backgroundView = self.activityIndicator
		$0.addSubview(self.refreshIndicator)
	}
	
	private lazy var teamsTableView = UITableView(frame: .zero, style: .plain).apply {
		$0.backgroundColor = .systemGray6
		$0.isHidden = true
	}
	
	private lazy var activityIndicator: UIActivityIndicatorView? = UIActivityIndicatorView(style: .medium)
	
	private lazy var refreshIndicator = UIRefreshControl().apply {
		$0.addTarget(self, action: #selector(self.pulledToRefresh), for: .valueChanged)
	}
	
	// MARK: Properties
	
	private var tabs: [String] {[
		NSLocalizedString(
			"UsersAndTeams.athletesTab",
			comment: "Users and teams screen, athletes tab"
		),
		NSLocalizedString(
			"UsersAndTeams.teamsTab",
			comment: "Users and teams screen, athletes tab"
		)
	]}
	
	// MARK: - Life cycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.setupUserListStateObserver()
		self.setupViews()
		self.viewModel.fetchUsers()
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		self.view.endEditing(true)
	}
	
	// MARK: - Actions
	
	@objc private func pulledToRefresh() {
		self.userCollectionView.backgroundView?.isHidden = true
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
			case .errorFetching:
				let errorFetching = NSLocalizedString("SimpleEmptyState.errorFetchingUsers", comment: "Empty state error fetching users")
				self.userCollectionView.backgroundView = SimpleEmptyStateLabel.create(text: errorFetching)
				self.userCollectionView.backgroundView?.isHidden = false
			case .performedSearch(let emptyResult):
				if emptyResult {
					let noResults = NSLocalizedString("SimpleEmptyState.noResults", comment: "Empty state no results")
					self.userCollectionView.backgroundView = SimpleEmptyStateLabel.create(text: noResults)
					self.userCollectionView.backgroundView?.isHidden = false
				} else {
					self.userCollectionView.backgroundView?.isHidden = true
				}
				self.userCollectionView.reloadData()
			}
		}
	}
	
	private func setupViews() {
		
		self.searchBar.placeholder = NSLocalizedString(
			"UsersAndTeams.searchPlaceholder",
			comment: "Users and teams screen, search searchbar placeholder"
		)
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
		self.view.backgroundColor = .systemGray6
	}
	
	//
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		guard segue.identifier == UserDetailViewController.segueId else {
			log.error(
				"Trying to performSegue to other than \(UserDetailViewController.segueId)",
				context: ["segue id": segue.identifier ?? "nil"]
			)
			return
		}
		guard let controller = segue.destination as? UserDetailViewController else {
			log.error(
				"Segue destination is not \(UserDetailViewController.self)",
				context: ["segue destination": "\(segue.destination)"]
			)
			return
		}
		controller.viewModel.user = sender as? User
	}
}

// MARK: - UICollectionViewDelegate
extension UsersAndTeamsViewController: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		performSegue(
			withIdentifier: UserDetailViewController.segueId,
			sender: self.viewModel.usersDataSource.displayedUsers[indexPath.row]
		)
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
	
	func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
		if case .loading = viewModel.userListState {
			self.view.endEditing(true)
			return false
		}
		return true
	}
}

// MARK: - UICollectionViewDelegateFlowLayout
extension UsersAndTeamsViewController: UICollectionViewDelegateFlowLayout {
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		userCollectionView.reloadData()
	}
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: self.view.frame.width - self.view.safeAreaInsets.left - self.view.safeAreaInsets.right, height: 100)
	}
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		return 0
	}
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return 0
	}
}
