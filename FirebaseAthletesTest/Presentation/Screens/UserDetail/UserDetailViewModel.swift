//
//  UserDetailViewModel.swift
//  FirebaseAthletesTest
//
//  Created by Daniel Illescas Romero on 22/01/2020.
//  Copyright © 2020 Daniel Illescas Romero. All rights reserved.
//

import Foundation

class UserDetailViewModel {
	
	var user: User!
	
	func chartWeightsData() -> [(x: Double, y: Double)] {
		user.weights.sorted { lhs, rhs in
			lhs.key.timeIntervalSince1970 < rhs.key.timeIntervalSince1970
		}.map {
			($0.key.timeIntervalSince1970, Double($0.value))
		}
	}
	
	func formattedUserWeightDate(_ date: Date) -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateStyle = .short
		return dateFormatter.string(from: date)
	}
	
	func userSportEmoji() -> String {
		switch user.sport {
		case .football: return " ⚽️"
		case .basketball: return " 🏀"
		case .baseball: return " ⚾️"
		case .rugby: return " 🏉"
		default:
			log.warning("Found unknown sport")
			return ""
		}
	}
}
