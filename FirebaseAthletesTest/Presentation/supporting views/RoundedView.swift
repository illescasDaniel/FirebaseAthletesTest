//
//  RoundedView.swift
//  FirebaseAthletesTest
//
//  Created by Daniel Illescas Romero on 21/01/2020.
//  Copyright © 2020 Daniel Illescas Romero. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedView: UIView {
	
	override func layoutSubviews() {
		super.layoutSubviews()
		self.layer.cornerRadius = self.frame.width / 2
	}
	
	override func addSubview(_ view: UIView) {
		super.addSubview(view)
		view.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			view.heightAnchor.constraint(equalTo: self.heightAnchor),
			view.centerXAnchor.constraint(equalTo: self.centerXAnchor)
		])
	}
}
