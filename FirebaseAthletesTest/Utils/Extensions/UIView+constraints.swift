//
//  UIView+constraints.swift
//  FirebaseAthletesTest
//
//  Created by Daniel Illescas Romero on 20/01/2020.
//  Copyright © 2020 Daniel Illescas Romero. All rights reserved.
//

import UIKit

extension UIView {
	func snapToParent(_ parent: UIView, insets: UIEdgeInsets = .zero) {
		self.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			self.topAnchor.constraint(equalTo: parent.topAnchor, constant: insets.top),
			self.leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: insets.left),
			self.trailingAnchor.constraint(equalTo: parent.trailingAnchor, constant: -insets.right),
			self.bottomAnchor.constraint(equalTo: parent.bottomAnchor, constant: -insets.bottom)
		])
	}
}
