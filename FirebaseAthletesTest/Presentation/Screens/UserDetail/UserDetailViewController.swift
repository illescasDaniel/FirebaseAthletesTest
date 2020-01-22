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
	
	@IBOutlet private weak var sportLabel: UILabel!
	@IBOutlet private weak var chartViewContainer: UIView!
	
	// MARK: - Views
	
	private lazy var smallAvatarInitialsView = UIView().apply { titleView in
		let roundedInitialsView = RoundedView().apply {
			$0.backgroundColor = .systemIndigo
			$0.addSubview(UILabel().apply {
				$0.font = UIFont.monospacedDigitSystemFont(ofSize: 16, weight: .bold)
				$0.textColor = .white
				$0.text = viewModel.user.initials
			})
		}
		titleView.addSubview(roundedInitialsView)
		roundedInitialsView.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			roundedInitialsView.widthAnchor.constraint(equalToConstant: 30),
			roundedInitialsView.heightAnchor.constraint(equalToConstant: 30),
			roundedInitialsView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor),
			roundedInitialsView.centerXAnchor.constraint(equalTo: titleView.centerXAnchor)
		])
	}
	
	private lazy var chartView = SportChartView(
		data: viewModel.chartWeightsData(),
		xLabelsFormatter: { (index, xValue) in
			self.viewModel.formattedUserWeightDate(Date(timeIntervalSince1970: TimeInterval(xValue)))
		},
		yLabelsFormatter: { (index, yValue) in
			// I assume is Kg! (but there's no specification for that)
			String(format: "%.2f Kg", yValue)
		}
	)
	
	// MARK: Data
	lazy var viewModel = UserDetailViewModel()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.setupViews()
	}
	
	// MARK: Convenience
	
	private func setupViews() {
		
		self.navigationItem.titleView = smallAvatarInitialsView
		self.navigationItem.title = viewModel.user.fullName
		
		self.fillSportLabel()
		
		let chartUIView = chartView.makeUIView()
		chartViewContainer.addSubview(chartUIView)
		chartUIView.snapToParent(chartViewContainer)
		chartView.updateUIView(chartUIView)
	}
	
	private func fillSportLabel() {
		let attributedSportText = NSMutableAttributedString(string: "Sport" + "\n", attributes: [
			.font: UIFont.boldSystemFont(ofSize: 24)
		])
		let sportName = viewModel.user.sport?.rawValue ?? "unknown"
		attributedSportText.append(NSAttributedString(
			string: " \(sportName.first!.uppercased() + sportName.dropFirst().lowercased())\(self.viewModel.userSportEmoji())",
			attributes: [
				.font: UIFont.systemFont(ofSize: 20)
			])
		)
		sportLabel.attributedText = attributedSportText
	}
}
