//
//  Sport.swift
//  FirebaseAthletesTest
//
//  Created by Daniel Illescas Romero on 22/01/2020.
//  Copyright © 2020 Daniel Illescas Romero. All rights reserved.
//

import Foundation

// TODO: localize
// Based on firebase data. The types of sports may grow, so using an enum to distinguish them
// is a good practice
enum Sport: String, Codable {
	case football
	case basketball
	case baseball
	case rugby
	
	
}
