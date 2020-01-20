//
//  UserList.swift
//  FirebaseAthletesTest
//
//  Created by Daniel Illescas Romero on 20/01/2020.
//  Copyright © 2020 Daniel Illescas Romero. All rights reserved.
//

import Foundation

struct UserList {
	
	struct Item: Codable {
		let id: String
		let value: User
	}
	let items: [Item]
	
	init(keyValuePairs: [(String, User)]) {
		self.items = keyValuePairs.map {
			.init(id: $0.0, value: $0.1)
		}
	}
}
