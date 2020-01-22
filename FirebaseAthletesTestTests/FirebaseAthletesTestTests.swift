//
//  FirebaseAthletesTestTests.swift
//  FirebaseAthletesTestTests
//
//  Created by Daniel Illescas Romero on 20/01/2020.
//  Copyright © 2020 Daniel Illescas Romero. All rights reserved.
//

import XCTest
@testable import FirebaseAthletesTest

class FirebaseAthletesTestTests: XCTestCase {
	
	override func setUp() {
		// Put setup code here. This method is called before the invocation of each test method in the class.
	}
	
	override func tearDown() {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
	}
	
	func testUsersFetch() {
		let expectations = expectation(description: "user list expectation")
		expectations.assertForOverFulfill = true
		expectations.expectedFulfillmentCount = 1
		
		let repo = UserRepository()
		let userLimit: UInt = 4
		repo.users(orderedByChild: .name, limit: userLimit) { (userList) in
			switch userList {
			case .success(let validUserList):
				XCTAssertTrue(UInt(validUserList.items.count) <= userLimit)
				XCTAssertEqual(validUserList.items, validUserList.items.sorted { $0.value.name < $1.value.name })
				expectations.fulfill()
			case .failure(let error):
				XCTFail(error.localizedDescription)
			}
		}
		
		wait(for: [expectations], timeout: 10)
	}
	
	/********                                                                              *******/
	/*** I can't test these cases, since I have no "write" permissions  ***/
	/********                                                                              *******/
	
	/*
	
	func testUserCreation() {
		let expectations = expectation(description: "user list expectation")
		expectations.assertForOverFulfill = true
		expectations.expectedFulfillmentCount = 2
		
		let repo = UserRepository()
		let newUser = User(name: "Daniel", surname: "Illescas", sport: .baseball, weights: [
			Date(): 70
		])
		repo.newUser(
			id: "aNewUser\(Int.random(in: Int.min...Int.max))",
			user: newUser
		) { error in
			if let error = error {
				XCTFail("Can't add new users \(error.localizedDescription)")
				return
			}
			expectations.fulfill()
			repo.users { (userList) in
				switch userList {
				case .success(let validUserList):
					let users = validUserList.items.map { $0.value }
					XCTAssertTrue(users.contains(newUser))
				case .failure(let error):
					XCTFail(error.localizedDescription)
				}
				expectations.fulfill()
			}
		}
		
		wait(for: [expectations], timeout: 10)
	}
	
	func testUpdateUser() {
		let expectations = expectation(description: "user list expectation")
		expectations.assertForOverFulfill = true
		expectations.expectedFulfillmentCount = 3
		
		let repo = UserRepository()
		let newUser = User(name: "Daniel", surname: "Illescas", sport: .baseball, weights: [
			Date(): 70
		])
		
		let newUserId = "aNewUser\(Int.random(in: Int.min...Int.max))"
		let newName = "Pepe"
		
		repo.newUser(
			id: newUserId,
			user: newUser
		) { error in
			if let error = error {
				XCTFail("Can't add new users \(error.localizedDescription)")
				return
			}
			expectations.fulfill()
			repo.updateUser(id: newUserId, field: .name, value: newName) { (error) in
				if let error = error {
					XCTFail("Can't add new users \(error.localizedDescription)")
					return
				}
				expectations.fulfill()
				
				repo.users { (userList) in
					switch userList {
					case .success(let validUserList):
						if let user = validUserList.items.first(where: { $0.id == newUserId }) {
							XCTAssertTrue(user.value.name == newName)
						} else {
							XCTFail("No user found with id \(newUserId)")
						}
					case .failure(let error):
						XCTFail(error.localizedDescription)
					}
					expectations.fulfill()
				}
			}
		}
		
		wait(for: [expectations], timeout: 10)
	}
	
	func testUserDeletion() {
		let expectations = expectation(description: "user list expectation")
		expectations.assertForOverFulfill = true
		expectations.expectedFulfillmentCount = 2
		
		let repo = UserRepository()
		let newUser = User(name: "Daniel", surname: "Illescas_", sport: .baseball, weights: [
			Date(): 70
		])
		let newUserId = "aNewUser\(Int.random(in: Int.min...Int.max))"
		repo.newUser(
			id: newUserId,
			user: newUser
		) { error in
			if let error = error {
				XCTFail("Can't add new users \(error.localizedDescription)")
				return
			}
			expectations.fulfill()
			
			repo.deleteUser(id: newUserId) { (error) in
				if let error = error {
					XCTFail("Can't add new users \(error.localizedDescription)")
					return
				}
				expectations.fulfill()
			}
		}
		
		wait(for: [expectations], timeout: 10)
	}
	
	*/
}
