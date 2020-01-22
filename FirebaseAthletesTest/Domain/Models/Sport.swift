//
//  Sport.swift
//  FirebaseAthletesTest
//
//  Created by Daniel Illescas Romero on 22/01/2020.
//  Copyright © 2020 Daniel Illescas Romero. All rights reserved.
//

import Foundation

// Based on firebase data. The types of sports may grow, so using an enum to distinguish them
// is a good practice
enum Sport: String, Codable {
	
	case football
	case basketball
	case baseball
	case rugby
	
	var localized: String {
		switch self {
		case .football:
			return NSLocalizedString("Sport.football", comment: "Football sport name")
		case .basketball:
			return NSLocalizedString("Sport.basketball", comment: "Basketball sport name")
		case .baseball:
			return NSLocalizedString("Sport.baseball", comment: "Baseball sport name")
		case .rugby:
			return NSLocalizedString("Sport.rugby", comment: "Rugby sport name")
		}
	}
}
