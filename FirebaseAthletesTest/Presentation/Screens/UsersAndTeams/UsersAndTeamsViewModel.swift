//
//  UsersAndTeamsViewModel.swift
//  FirebaseAthletesTest
//
//  Created by Daniel Illescas Romero on 20/01/2020.
//  Copyright © 2020 Daniel Illescas Romero. All rights reserved.
//

import Foundation
import UIKit

class UsersAndTeamsViewModel {
	
	// MARK: Properties
	let usersDataSource = UsersDataSource()
	var propertyObservers: [NSKeyValueObservation] = []
	var userListStateObserver: (UsersListState) -> Void = {_ in }
	private(set) var userListState: UsersListState = .idle {
		didSet {
			self.userListStateObserver(self.userListState)
		}
	}
	
	// MARK: Methods
	
	func fetchUsers() {
		self.userListState = .loading
		self.usersDataSource.fetchUsers {
			self.userListState = .loaded
		}
	}
	
	/// It filters by the "name" property.
	/// If it doesn't find anything, it tries to filter by similar strings to the values of the "name" property
	/// finally it sorts the filtered list by similarity.
	///
	/// Thanks to swift's COW (copy on write) these arrays won't be copying themselves all the time
	func filterUsersList(withText searchText: String) {
		if searchText.isEmpty {
			self.usersDataSource.displayedUsers = self.usersDataSource.allUsers
		} else {
			let filteredUsers = self.usersDataSource.allUsers.lazy.filter { $0.name.contains(searchText) }
			let nextDisplayedUsers = filteredUsers.isEmpty
				? self.usersDataSource.allUsers.filter { $0.name.levenshteinDistanceScore(to: searchText) > 0.5 }
				: Array(filteredUsers)
			
			self.usersDataSource.displayedUsers = nextDisplayedUsers.sorted {
				$0.name.levenshteinDistanceScore(to: searchText) > $1.name.levenshteinDistanceScore(to: searchText)
			}
		}
		self.userListState = .performedSearch(emptyResult: self.usersDataSource.displayedUsers.isEmpty)
	}
	
	//
	deinit {
		propertyObservers.forEach { $0.invalidate() }
		propertyObservers.removeAll()
	}
}
extension UsersAndTeamsViewModel {
	enum UsersListState {
		case idle
		case loading
		case loaded
		case performedSearch(emptyResult: Bool)
	}
}
