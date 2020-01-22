//
//  UserCollectionViewCell.swift
//  FirebaseAthletesTest
//
//  Created by Daniel Illescas Romero on 20/01/2020.
//  Copyright © 2020 Daniel Illescas Romero. All rights reserved.
//

import UIKit

class UserCollectionViewCell: UICollectionViewCell {
	
	@IBOutlet private weak var containerView: UIView!
	@IBOutlet private weak var userNameAvatarContainer: RoundedView!
	@IBOutlet weak var userNameInitialsLabel: UILabel!
	@IBOutlet weak var userNameLabel: UILabel!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		containerView.layer.cornerRadius = 8
		userNameInitialsLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 20, weight: .bold)
	}
	
}
