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
		completionHandler: @escaping (Result<UserList, Error>) -> Void
	) {
		firebaseDataSource.users(orderedByChild: child?.rawValue, limit: limit) { snapshot in
			completionHandler(snapshot.map { UserList(keyValuePairs: $0.keyValuePairs()) })
		}
	}
	
	func newUser(id: String, user: User, completionHandler: @escaping (Error?) -> Void) {
		firebaseDataSource.newUser(id: id, userProperties: user.propertiesDictionary, completionHandler: completionHandler)
	}
	
	func updateUser(id: String, field: User.k, value: Any, completionHandler: @escaping (Error?) -> Void) {
		firebaseDataSource.updateUser(id: id, field: field.rawValue, value: value, completionHandler: completionHandler)
	}
	
	func deleteUser(id: String, completionHandler: @escaping (Error?) -> Void) {
		firebaseDataSource.deleteUser(id: id, completionHandler: completionHandler)
	}
	
}
