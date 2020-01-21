//
//  UserDetailViewController.swift
//  FirebaseAthletesTest
//
//  Created by Daniel Illescas Romero on 21/01/2020.
//  Copyright © 2020 Daniel Illescas Romero. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {
	
	static var segueId: String { "showUserDetail" }
	
	// MARK: - IBOutlets
	
	@IBOutlet weak var userNameInitialsLabel: UILabel!
	
	// MARK: Data
	// use a view model ???
	var user: User!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.setupViews()
	}
	
	// MARK: Convenience
	
	private func setupViews() {
		
		// custom view in "supporting views"
		let titleView = UIView()
		titleView.backgroundColor = .blue
		let roundedInitialsView = RoundedView().apply {
			$0.backgroundColor = .systemIndigo
			$0.addSubview(UILabel().apply {
				$0.font = UIFont.monospacedDigitSystemFont(ofSize: 18, weight: .bold)
				$0.textColor = .white
				$0.text = user.initials
			})
		}
		
		titleView.addSubview(roundedInitialsView)
		roundedInitialsView.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			roundedInitialsView.widthAnchor.constraint(equalToConstant: 40),
			roundedInitialsView.heightAnchor.constraint(equalToConstant: 40),
			roundedInitialsView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor),
			roundedInitialsView.centerXAnchor.constraint(equalTo: titleView.centerXAnchor)
		])
		self.navigationItem.titleView = titleView
		self.navigationItem.title = user.fullName
	}
}
