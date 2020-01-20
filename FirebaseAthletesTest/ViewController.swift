//
//  ViewController.swift
//  FirebaseAthletesTest
//
//  Created by Daniel Illescas Romero on 20/01/2020.
//  Copyright © 2020 Daniel Illescas Romero. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		
		let db: DatabaseReference = Database.database().reference()
		db.child("\(User.childKey)")
			.queryOrdered(byChild: "\(User.k.name)")
			.observeSingleEvent(of: .value) { (snapshot) in
				let userList = UserList(keyValuePairs: snapshot.keyValuePairs())
				print(userList)
		}
		/*db.child("users/POrvi93dcaDVa").observeSingleEvent(of: .value) { (snapshot) in
			dump(snapshot.value ?? "nil")
			guard let snapshotValue = snapshot.value as? [String: Any] else { return }
			do {
				print(try User(snapshotValue: snapshotValue))
			} catch {
				print(error)
			}
		}*/
	}


}

