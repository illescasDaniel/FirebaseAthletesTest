//
//  SimpleEmptyStateLabel.swift
//  FirebaseAthletesTest
//
//  Created by Daniel Illescas Romero on 21/01/2020.
//  Copyright © 2020 Daniel Illescas Romero. All rights reserved.
//

import UIKit

class SimpleEmptyStateLabel: UIView {
	static func create(text: String) -> SimpleEmptyStateLabel {
		SimpleEmptyStateLabel().apply {
			let emptyStateLabel = UILabel()
			emptyStateLabel.text = text
			emptyStateLabel.textAlignment = .center
			$0.addSubview(emptyStateLabel)
			emptyStateLabel.translatesAutoresizingMaskIntoConstraints = false
			NSLayoutConstraint.activate([
				emptyStateLabel.topAnchor.constraint(equalTo: $0.topAnchor, constant: 20),
				emptyStateLabel.leadingAnchor.constraint(equalTo: $0.leadingAnchor, constant: 16),
				emptyStateLabel.trailingAnchor.constraint(equalTo: $0.trailingAnchor, constant: -16),
				emptyStateLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 100)
			])
		}
	}
}
