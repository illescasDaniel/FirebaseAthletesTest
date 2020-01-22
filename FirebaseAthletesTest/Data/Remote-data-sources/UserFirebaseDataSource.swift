//
//  UserFirebaseDataSource.swift
//  FirebaseAthletesTest
//
//  Created by Daniel Illescas Romero on 20/01/2020.
//  Copyright © 2020 Daniel Illescas Romero. All rights reserved.
//

import Foundation
import Firebase

struct UserFirebaseDataSource {
	
	let database: DatabaseReference = Database.database().reference()
	
	var usersDatabase: DatabaseReference {
		database.child("\(User.childKey)")
	}
	
	func users(
		orderedByChild child: String? = nil,
		limit: UInt? = nil,
		completionHandler: @escaping (Result<DataSnapshot, Error>) -> Void
	) {
		var query: DatabaseQuery = usersDatabase
		if let childName = child {
			query = query.queryOrdered(byChild: childName)
		}
		if let limit = limit {
			query = query.queryLimited(toFirst: limit)
		}
		query.observeSingleEvent(of: .value, with: { (snapshot) in
			completionHandler(.success(snapshot))
		}) { (error) in
			log.error(error, context: ["child": child ?? "nil", "limit": limit ?? "nil"])
			completionHandler(.failure(error))
		}
	}
	
	func newUser(id: String, userProperties: [String: Any], completionHandler: @escaping (Error?) -> Void) {
		usersDatabase.child(id).setValue(userProperties) { (error, _) in
			log.error(error ?? "Error setting user properties", context: ["id": id, "User": userProperties])
			completionHandler(error)
		}
	}
	
	func updateUser(id: String, field: String, value: Any, completionHandler: @escaping (Error?) -> Void) {
		database.child("\(User.childKey)/\(id)/\(field)").setValue(value) { (error, _) in
			log.error(error ?? "Error updating user properties", context: ["id": id, "field": field, "value": value])
			completionHandler(error)
		}
	}
	
	func deleteUser(id: String, completionHandler: @escaping (Error?) -> Void) {
		database.child("\(User.childKey)/\(id)").removeValue() { (error, _) in
			log.error(error ?? "Error deleting user", context: ["id": id])
			completionHandler(error)
		}
	}
}
