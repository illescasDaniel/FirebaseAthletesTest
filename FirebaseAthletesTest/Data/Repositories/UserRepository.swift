//
//  UserRepository.swift
//  FirebaseAthletesTest
//
//  Created by Daniel Illescas Romero on 20/01/2020.
//  Copyright © 2020 Daniel Illescas Romero. All rights reserved.
//

import Foundation

protocol UserRepository {
	func users(
		orderedByChild child: User.k?,
		limit: UInt?,
		completionHandler: @escaping (Result<UserList, Error>) -> Void
	)
	func newUser(id: String, user: User, completionHandler: @escaping (Error?) -> Void)
	func updateUser(id: String, field: User.k, value: Any, completionHandler: @escaping (Error?) -> Void)
	func deleteUser(id: String, completionHandler: @escaping (Error?) -> Void)
}
