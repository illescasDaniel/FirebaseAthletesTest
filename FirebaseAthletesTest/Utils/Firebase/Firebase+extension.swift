//
//  Firebase+extension.swift
//  FirebaseAthletesTest
//
//  Created by Daniel Illescas Romero on 20/01/2020.
//  Copyright © 2020 Daniel Illescas Romero. All rights reserved.
//

import Foundation
import Firebase

extension DataSnapshot {
	func keyValuePairs<T: FirebaseDecodable>() -> [(String, T)] {
		
		guard let children = (self.children.allObjects as? [DataSnapshot]) else {
			return []
		}
		let childrenKeyValuePairs: [(String, T)] = children.compactMap { (snapshot) in
			guard let userDictionary = snapshot.value as? [String: Any],
				let user = try? T(snapshotValue: userDictionary) else { return nil }
			
			return (snapshot.key, user)
		}
		
		return childrenKeyValuePairs
    }
}
