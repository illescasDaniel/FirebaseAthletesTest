//
//  UserRepository.swift
//  FirebaseAthletesTest
//
//  Created by Daniel Illescas Romero on 20/01/2020.
//  Copyright © 2020 Daniel Illescas Romero. All rights reserved.
//

import Foundation

struct UserRepository {
	
	private let firebaseDataSource = UserFirebaseDataSource()
	
	func users(
		orderedByChild child: User.k? = nil,
		limit: UInt? = nil,
		completionHandler: @escaping (UserList) -> Void
	) {
		firebaseDataSource.users(orderedByChild: child?.rawValue, limit: limit) { snapshot in
			completionHandler(UserList(keyValuePairs: snapshot.keyValuePairs()))
		}
	}
	
	func newUser(id: String, user: User) {
		firebaseDataSource.newUser(id: id, userProperties: user.propertiesDictionary)
	}
	
	func updateUser(id: String, field: User.k, value: Any) {
		firebaseDataSource.updateUser(id: id, field: field.rawValue, value: value)
	}
	
	func deleteUser(id: String) {
		firebaseDataSource.deleteUser(id: id)
	}
	
}
