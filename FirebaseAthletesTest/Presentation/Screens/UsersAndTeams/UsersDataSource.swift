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
	let userRepository: UserRepository = {
		#if MOCK
		return MockUserRepository()
		#else
		return DefaultUserRepository()
		#endif
	}()
	
	// data
	private(set) var allUsers: [User] = []
	var displayedUsers: [User] = []
	
	// public methods
	func fetchUsers(completionHandler: @escaping (Error?) -> Void) {
		userRepository.users(orderedByChild: .name, limit: nil) { (userList) in
			switch userList {
			case .success(let validUserList):
				self.allUsers = validUserList.items.map { $0.value }
				self.displayedUsers = self.allUsers
				completionHandler(nil)
			case .failure(let error):
				self.displayedUsers = []
				log.error(error)
				completionHandler(error)
			}
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
		
		cell.userNameInitialsLabel.text = user.initials
		return cell
	}
}
