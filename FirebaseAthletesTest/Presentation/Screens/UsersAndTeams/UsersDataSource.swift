//
//  UsersDataSource.swift
//  FirebaseAthletesTest
//
//  Created by Daniel Illescas Romero on 20/01/2020.
//  Copyright © 2020 Daniel Illescas Romero. All rights reserved.
//

import UIKit
import Firebase

class UsersDataSource: NSObject {
	
	// dependencies
	let userRepository = UserRepository()
	
	// data
	private(set) var allUsers: [User] = []
	var displayedUsers: [User] = []
	
	// public methods
	func fetchUsers(completionHandler: @escaping () -> Void) {
		userRepository.users(orderedByChild: .name) { (userList) in
			self.allUsers = userList.items.map { $0.value }
			self.displayedUsers = self.allUsers
			completionHandler()
		}
	}
}

// MARK: - UICollectionViewDataSource
extension UsersDataSource: UICollectionViewDataSource {
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		1
	}
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		self.displayedUsers.count
	}
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(UserCollectionViewCell.self)", for: indexPath) as? UserCollectionViewCell else {
			fatalError("Incorrect cell class")
		}
		let user = self.displayedUsers[indexPath.row]
		cell.userNameLabel.text = user.name
		return cell
	}
}
