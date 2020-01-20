//
//  ViewController.swift
//  FirebaseAthletesTest
//
//  Created by Daniel Illescas Romero on 20/01/2020.
//  Copyright © 2020 Daniel Illescas Romero. All rights reserved.
//

import UIKit
import Firebase

class UsersAndTeamsViewController: UIViewController {
	
	// MARK: Views
	lazy var userCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
	lazy var usersDataSource = UsersDataSource()
	lazy var teamsTableView = UITableView(frame: .zero, style: .plain)
	lazy var searchController = UISearchController(searchResultsController: nil)
	lazy var activityIndicator = UIActivityIndicatorView(style: .medium)
	
	// MARK: Data
	//var allUsers: [User] = []
	//var displayedUsers: [User] = []

	override func viewDidLoad() {
		super.viewDidLoad()
		
		
		self.view.addSubview(userCollectionView)
		userCollectionView.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			userCollectionView.topAnchor.constraint(equalTo: self.view.topAnchor),
			userCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
			userCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
			userCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
		])
		self.userCollectionView.backgroundColor = .systemGroupedBackground
		
		self.view.addSubview(teamsTableView)
		teamsTableView.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			teamsTableView.topAnchor.constraint(equalTo: self.view.topAnchor),
			teamsTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
			teamsTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
			teamsTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
		])
		self.teamsTableView.backgroundColor = .systemGroupedBackground
		teamsTableView.isHidden = true

		
		//
		
		self.userCollectionView.register(
			UINib(nibName: "\(UserCollectionViewCell.self)", bundle: .main),
			forCellWithReuseIdentifier: "\(UserCollectionViewCell.self)"
		)
		self.userCollectionView.dataSource = self.usersDataSource
		self.userCollectionView.delegate = self
		
		//
		
		self.title = "Athlets"
		
		self.searchController.obscuresBackgroundDuringPresentation = false
		self.searchController.searchResultsUpdater = self
		self.searchController.searchBar.scopeButtonTitles = ["Athlets", "Teams"]
		self.searchController.searchBar.selectedScopeButtonIndex = 0
		self.searchController.searchBar.showsScopeBar = true
		self.searchController.searchBar.delegate = self
		
		self.navigationItem.searchController = searchController
		self.definesPresentationContext = true
		
		//
		
		self.userCollectionView.backgroundView = self.activityIndicator
		self.activityIndicator.startAnimating()
		let db: DatabaseReference = Database.database().reference()
		db.child("\(User.childKey)")
			.queryOrdered(byChild: "\(User.k.name)")
			.observeSingleEvent(of: .value) { (snapshot) in
				let userList = UserList(keyValuePairs: snapshot.keyValuePairs())
				self.usersDataSource.allUsers = userList.items.map { $0.value }
				self.usersDataSource.displayedUsers = self.usersDataSource.allUsers
				
				self.activityIndicator.stopAnimating()
				self.userCollectionView.backgroundView?.isHidden = true
				
				self.userCollectionView.reloadData()
		}
	}
}

extension UsersAndTeamsViewController: UISearchBarDelegate {
	func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
		if selectedScope == 0 {
			self.teamsTableView.isHidden = true
			self.userCollectionView.isHidden = false
		} else {
			self.teamsTableView.isHidden = false
			self.userCollectionView.isHidden = true
		}
	}
}

extension UsersAndTeamsViewController: UISearchResultsUpdating {
	func updateSearchResults(for searchController: UISearchController) {
		let searchText = searchController.searchBar.text ?? ""
		if searchText.isEmpty {
			self.usersDataSource.displayedUsers = self.usersDataSource.allUsers
		} else {
			let filteredUsers = self.usersDataSource.allUsers.filter { $0.name.contains(searchText) }
			if filteredUsers.isEmpty {
				self.usersDataSource.displayedUsers = self.usersDataSource.allUsers.filter { $0.name.levenshteinDistanceScore(to: searchText) > 0.45 }
			} else {
				self.usersDataSource.displayedUsers = filteredUsers
			}
		}
		self.userCollectionView.reloadData()
	}
}
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
