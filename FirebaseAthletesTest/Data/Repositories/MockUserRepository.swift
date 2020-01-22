//
//  MockUserRepository.swift
//  FirebaseAthletesTest
//
//  Created by Daniel Illescas Romero on 22/01/2020.
//  Copyright © 2020 Daniel Illescas Romero. All rights reserved.
//

import Foundation

struct MockUserRepository: UserRepository {
	
	private let firebaseDataSource = UserFirebaseDataSource()
	
	func users(
		orderedByChild child: User.k? = nil,
		limit: UInt? = nil,
		completionHandler: @escaping (Result<UserList, Error>) -> Void
	) {
		completionHandler(.success(UserList(keyValuePairs: [
			("key1", User(name: "Daniel", surname: "Illescas", sport: .football, weights: [
				Date(): 10,
				Date().addingTimeInterval(10): 20,
				Date().addingTimeInterval(20): 30,
				Date().addingTimeInterval(30): 40,
			])),
			("key2", User(name: "Daniel", surname: "Illescas", sport: .football, weights: [
				Date(): 10,
				Date().addingTimeInterval(10): 20,
				Date().addingTimeInterval(20): 30,
				Date().addingTimeInterval(30): 40,
			])),
			("key3", User(name: "Daniel", surname: "Illescas", sport: .football, weights: [
				Date(): 10,
				Date().addingTimeInterval(10): 20,
				Date().addingTimeInterval(20): 30,
				Date().addingTimeInterval(30): 40,
			]))
		])))
	}
	
	func newUser(id: String, user: User, completionHandler: @escaping (Error?) -> Void) {
		
	}
	
	func updateUser(id: String, field: User.k, value: Any, completionHandler: @escaping (Error?) -> Void) {
		
	}
	
	func deleteUser(id: String, completionHandler: @escaping (Error?) -> Void) {
		
	}
}
