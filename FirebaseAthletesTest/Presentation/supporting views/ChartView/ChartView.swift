//
//  ChartView.swift
//  FirebaseAthletesTest
//
//  Created by Daniel Illescas Romero on 22/01/2020.
//  Copyright © 2020 Daniel Illescas Romero. All rights reserved.
//

import UIKit

// Since "kCALineJoinBevel" is deprecated, I need to manually import the SwiftChar framework...

final class SportChartView: ChartDelegate {
	
	typealias UIViewType = Chart
	
	let data: [(x: Double, y: Double)]
	let xLabelsFormatter: (Int, Double) -> String
	let yLabelsFormatter: (Int, Double) -> String
	
	init(data: [(x: Double, y: Double)], xLabelsFormatter: @escaping (Int, Double) -> String, yLabelsFormatter: @escaping (Int, Double) -> String) {
		self.data = data
		self.xLabelsFormatter = xLabelsFormatter
		self.yLabelsFormatter = yLabelsFormatter
	}
	
	func makeUIView() -> Chart {
		let chart = Chart()
		chart.delegate = self
		chart.hideHighlightLineOnTouchEnd = true
		
		let series = ChartSeries(data: self.data)
		series.area = true
		chart.add(series)
		
		return chart
	}
	
	func updateUIView(_ uiView: Chart) {
		
		uiView.layoutIfNeeded()
		
		uiView.removeAllSeries()
		
		let series = ChartSeries(data: self.data)
		series.area = true
		uiView.add(series)
		
		uiView.yLabelsFormatter = self.yLabelsFormatter
		if self.data.count > 10 {
			uiView.xLabelsFormatter = { (_,_) in "" }
		} else {
			uiView.xLabelsFormatter = self.xLabelsFormatter
		}
		
		uiView.labelColor = .label
	}
	
	// MARK: - ChartDelegate
	
	// Maybe we could show the money ammount where the user is tapping
	// But where do we show it or how? Does it make sense? Is it worth it?
	
	func didTouchChart(_ chart: Chart, indexes: [Int?], x: Double, left: CGFloat) {
		
	}
	
	func didFinishTouchingChart(_ chart: Chart) {
		
	}
	
	func didEndTouchingChart(_ chart: Chart) {
		
	}
}
