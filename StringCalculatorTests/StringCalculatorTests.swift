//
//  StringCalculatorTests.swift
//  StringCalculatorTests
//
//  Created by Mohammed Saqib on 29/06/25.
//

import XCTest
@testable import StringCalculator

final class CalculatorAppTests: XCTestCase {
	
	var calculatorAppVM: CalculatorAppViewModel!

	override func setUpWithError() throws {
		calculatorAppVM = CalculatorAppViewModel()
	}

	override func tearDownWithError() throws {
		calculatorAppVM = nil
		
	}

	func testCheckEmptyString() throws {
		let result = try calculatorAppVM.add("")
		XCTAssertEqual(result, 0, "Empty string should return zero")
	}
	
	func testEmptySpaces() throws {
		let result = try calculatorAppVM.add("   ")
		XCTAssertEqual(result, 0, "Only white spaces are not allowed")
	}
	
	func testDoesNotContainAnyNumber() throws {
		let result = try calculatorAppVM.add(",\n")
		XCTAssertEqual(result, 0, "Should return 0 when there are no numbers")
		
	}
	
	func testContainsNegativeNumber() throws {
		let numbers = "1,-2,3,-5"
		XCTAssertThrowsError(try calculatorAppVM.add(numbers)) { error in
			guard case let NumbersError.containsNegativeNumbers(numbers) = error else {
				return XCTFail("Expected NumbersError.continsNegativeNumbers")
			}
			
			XCTAssertEqual(numbers, [-2, -5])
		}
	}
	
	func testInputTooShort() throws {
		XCTAssertThrowsError(try calculatorAppVM.add("//"))
	}
	
	func testNormalInput() throws {
		let numbers = "1,2,3,4"
		XCTAssertEqual(try calculatorAppVM.add(numbers), 10)
	}
	
	func testInputWithNewlines() throws {
		let numbers = "1\n2,3\n4"
		XCTAssertEqual(try calculatorAppVM.add(numbers), 10)
	}
	
	func testInputWithCustomDelimeter() {
		let numbers = "//-\n1-2-3"
		XCTAssertEqual(try calculatorAppVM.add(numbers), 6)
	}

}
