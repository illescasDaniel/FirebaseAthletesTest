//
//  FirebaseModel.swift
//  FirebaseAthletesTest
//
//  Created by Daniel Illescas Romero on 20/01/2020.
//  Copyright © 2020 Daniel Illescas Romero. All rights reserved.
//

import Foundation
import Firebase

protocol FirebaseDecodable: Decodable {
	init(snapshotValue: [String: Any]) throws
}
extension FirebaseDecodable {
	
	init(snapshotValue: [String: Any]) throws {
		let data = try JSONSerialization.data(withJSONObject: snapshotValue)
		self = try JSONDecoder().decode(Self.self, from: data)
	}
}

protocol FirebaseCodingKeys: CodingKey, RawRepresentable where Self.RawValue == String {}
extension FirebaseCodingKeys {
	var description: String { self.rawValue }
}

protocol FirebaseEncodable: Encodable {
	associatedtype CodingKeys: FirebaseCodingKeys
	var propertiesDictionary: [String: Any] { get }
}
extension FirebaseEncodable {
	typealias k = Self.CodingKeys
	var propertiesDictionary: [String: Any] {
		guard let data = try? JSONEncoder().encode(self) else { return [:] }
		return ((try? JSONSerialization.jsonObject(with: data)) as? [String: Any]) ?? [:]
	}
}

protocol FirebaseCodable: FirebaseDecodable, FirebaseEncodable {
	static var childKey: String { get }
}
extension FirebaseCodable {
	static var childKey: String { "\(Self.self)".lowercased() }
}


protocol FirebaseModel: FirebaseCodable {}
