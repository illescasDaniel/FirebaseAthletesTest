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
		completionHandler: @escaping (DataSnapshot) -> Void
	) {
		var query: DatabaseQuery = usersDatabase
		if let childName = child {
			query = query.queryOrdered(byChild: childName)
		}
		if let limit = limit {
			query = query.queryLimited(toFirst: limit)
		}
		query.observeSingleEvent(of: .value) { (snapshot) in
			completionHandler(snapshot)
		}
	}
	
	func newUser(id: String, userProperties: [String: Any]) {
		usersDatabase.child(id).setValue(userProperties)
	}
	
	func updateUser(id: String, field: String, value: Any) {
		database.child("\(User.childKey)/\(id)/\(field)").setValue(value)
	}
	
	func deleteUser(id: String) {
		database.child("\(User.childKey)/\(id)").removeValue()
	}
}
