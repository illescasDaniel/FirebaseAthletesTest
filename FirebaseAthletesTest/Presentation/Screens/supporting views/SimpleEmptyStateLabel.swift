//
//  SimpleEmptyStateLabel.swift
//  FirebaseAthletesTest
//
//  Created by Daniel Illescas Romero on 21/01/2020.
//  Copyright © 2020 Daniel Illescas Romero. All rights reserved.
//

import UIKit

class SimpleEmptyStateLabel: UIView {
	static func create() -> SimpleEmptyStateLabel {
		let emptyStateView = SimpleEmptyStateLabel()
		let emptyStateLabel = UILabel()
		emptyStateLabel.text = "No results"
		emptyStateLabel.textAlignment = .center
		emptyStateView.addSubview(emptyStateLabel)
		emptyStateLabel.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			emptyStateLabel.topAnchor.constraint(equalTo: emptyStateView.topAnchor, constant: 20),
			emptyStateLabel.leadingAnchor.constraint(equalTo: emptyStateView.leadingAnchor, constant: 16),
			emptyStateLabel.trailingAnchor.constraint(equalTo: emptyStateView.trailingAnchor, constant: -16),
			emptyStateLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 100)
		])
		return emptyStateView
	}
}
