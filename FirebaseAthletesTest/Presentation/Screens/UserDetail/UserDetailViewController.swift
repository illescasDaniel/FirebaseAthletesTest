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
				$0.font = UIFont.monospacedDigitSystemFont(ofSize: 16, weight: .bold)
				$0.textColor = .white
				$0.text = user.initials
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
		self.navigationItem.titleView = titleView
		self.navigationItem.title = user.fullName
		
		//
		let sportEmoji: String
		switch user.sport {
		case .football: sportEmoji = " ⚽️"
		case .basketball: sportEmoji = " 🏀"
		case .baseball: sportEmoji = " ⚾️"
		case .rugby: sportEmoji = " 🏉"
		default:
			sportEmoji = ""
		}
		
		let attributedSportText = NSMutableAttributedString(string: "Sport" + "\n", attributes: [
			.font: UIFont.boldSystemFont(ofSize: 24)
		])
		let sportName = user.sport?.rawValue ?? "unknown"
		attributedSportText.append(NSAttributedString(
			string: " \(sportName.first!.uppercased() + sportName.dropFirst().lowercased())\(sportEmoji)",
			attributes: [
				.font: UIFont.systemFont(ofSize: 20)
			])
		)
		sportLabel.attributedText = attributedSportText
		
		//
		
		let chartWeightsData: [(x: Double, y: Double)] = user.weights.sorted { lhs, rhs in
			lhs.key.timeIntervalSince1970 < rhs.key.timeIntervalSince1970
		}.map {
			($0.key.timeIntervalSince1970, Double($0.value))
		}
		
		let chartView = SportChartView(
			data: chartWeightsData,
			xLabelsFormatter: { (index, xValue) in
				let date = Date(timeIntervalSince1970: TimeInterval(xValue))
				let dateFormatter = DateFormatter()
				dateFormatter.dateStyle = .short
				return dateFormatter.string(from: date)
			},
			yLabelsFormatter: { (index, yValue) in
				// I assume is Kg! (but there's no specification for that)
				String(format: "%.2f Kg", yValue)
			}
		)
		let chartUIView = chartView.makeUIView()
		chartViewContainer.addSubview(chartUIView)
		chartUIView.snapToParent(chartViewContainer)
		chartView.updateUIView(chartUIView)
	}
}
