//
//  User.swift
//  FirebaseAthletesTest
//
//  Created by Daniel Illescas Romero on 20/01/2020.
//  Copyright © 2020 Daniel Illescas Romero. All rights reserved.
//

import Foundation

struct User: Equatable {
	
	static var childKey: String { "users" }
	
	let name: String
	let surname: String
	let sport: Sport?
	let weights: [Date: Float]
	
	init(
		name: String,
		surname: String,
		sport: Sport?,
		weights: [Date: Float]
	) {
		self.name = name
		self.surname = surname
		self.sport = sport
		self.weights = weights
	}
}

extension User {
	var initials: String {
		var initialsString = ""
		if let firstNameLetter = self.name.first {
			initialsString += String(firstNameLetter)
		}
		if let firstSurnameLetter = self.surname.first {
			initialsString += String(firstSurnameLetter)
		}
		return initialsString
	}
	
	var fullName: String {
		return "\(self.name) \(self.surname)"
	}
}

//

extension User: FirebaseModel {
	
	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		self.name = try container.decode(String.self, forKey: .name)
		self.surname = try container.decode(String.self, forKey: .surname)
		self.sport = try? container.decode(Sport.self, forKey: .sport)
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
	
	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(self.name, forKey: .name)
		try container.encode(self.surname, forKey: .surname)
		try container.encode(self.sport, forKey: .sport)
		let originalWeights = [String: Float](self.weights.map { (keyValue) -> (String, Float) in
			let (key, value) = keyValue
			let dateFormatter = DateFormatter()
			dateFormatter.dateFormat = "yyyy-MM-dd"
			return (dateFormatter.string(from: key), value)
		}, uniquingKeysWith: { $1 })
		try container.encode(originalWeights, forKey: .weights)
	}
	
	enum CodingKeys: String, FirebaseCodingKeys {
		case name, surname, sport, weights
	}
}
