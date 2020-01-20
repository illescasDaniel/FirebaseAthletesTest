//
//  ApplyProtocol.swift
//  FirebaseAthletesTest
//
//  Created by Daniel Illescas Romero on 20/01/2020.
//  Copyright © 2020 Daniel Illescas Romero. All rights reserved.
//

import Foundation

protocol ApplyProtocol {}
extension ApplyProtocol {
	func apply(closure: (Self) -> Void) -> Self {
		closure(self)
		return self
	}
}

#if canImport(ObjectiveC)
extension NSObject: ApplyProtocol {}
#else
extension UIView: ApplyProtocol {}
extension UIViewController: ApplyProtocol {}
extension BaseComponentView: ApplyProtocol {}
#endif
