//
//  User.swift
//  FirebaseAthletesTest
//
//  Created by Daniel Illescas Romero on 20/01/2020.
//  Copyright © 2020 Daniel Illescas Romero. All rights reserved.
//

import Foundation

struct User: FirebaseModel {
	
	static var childKey: String { "users" }
	
	let name: String
	let surname: String
	let sport: String
	let weights: [Date: Float]
	
	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		self.name = try container.decode(String.self, forKey: .name)
		self.surname = try container.decode(String.self, forKey: .surname)
		self.sport = try container.decode(String.self, forKey: .sport)
		let rawWeights = try container.decode([String: Float].self, forKey: .weights)
		self.weights = [Date: Float](rawWeights.compactMap { (keyValue) -> (Date, Float)? in
			let (key, value) = keyValue
			let dateFormatter = DateFormatter()
			dateFormatter.dateFormat = "yyyy-MM-dd"
			guard let date = dateFormatter.date(from: key) else {
				return nil
			}
			return (date, value)
		}, uniquingKeysWith: { $1 })
	}
	
	enum CodingKeys: String, FirebaseCodingKeys {
		case name, surname, sport, weights
	}
}
