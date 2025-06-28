//
//  CalculatorAppViewModel.swift
//  StringCalculator
//
//  Created by Mohammed Saqib on 29/06/25.
//

import Foundation

enum NumbersError: Error, CustomStringConvertible {
	case containsNegativeNumbers([Int])
	case inputTooShort
	
	var description: String {
		switch self {
		case .containsNegativeNumbers(let negativeNums):
			return "Negative numbers found: \(negativeNums.map(String.init).joined(separator: ", "))"
		case .inputTooShort:
			return "numbers length is too short"
		}
	}
}

class CalculatorAppViewModel: ObservableObject {
	
	private func getCustomDelimeter(_ numbers: String) throws -> String {
		guard !(numbers.hasPrefix("//") && numbers.count <= 2) else {
			throw NumbersError.inputTooShort
		}
		
		var delimeter = ","
		
		if numbers.hasPrefix("//") {
			let index = numbers.index(numbers.startIndex, offsetBy: 2)
			delimeter = String(numbers[index])
		}
		
		return delimeter
	}
	
	private func getSum(_ numbersList: [Int]) -> Int {
		return numbersList.reduce(0, +)
	}
	
	private func replaceNewlines(_ numbers: String, withDelimeter delimeter: String) -> String {
		return numbers.replacingOccurrences(of: "\n", with: delimeter)
	}
	
	private func replaceHeader(_ numbers: String) -> String {
		let index = numbers.index(numbers.startIndex, offsetBy: 4)
		return String(numbers[index...])
	}
	
	func add(_ numbers: String) throws -> Int {
		if numbers.trimmingCharacters(in: .whitespaces).isEmpty {
			return 0
		}
		
		let customDelimeter = try getCustomDelimeter(numbers)
		
		var numberPart = numbers
		if numbers.hasPrefix("//") {
			numberPart = replaceHeader(numbers)
		}
		
		let newNumbers = replaceNewlines(numberPart, withDelimeter: customDelimeter)
		
		let numbersList = newNumbers
			.split(separator: customDelimeter)
			.compactMap({ Int($0) })

		let negativeNumbers = numbersList.filter({ $0 < 0 })
		
		if !negativeNumbers.isEmpty {
			throw NumbersError.containsNegativeNumbers(negativeNumbers)
		}
		
		let totalSum = getSum(numbersList)
		
		return totalSum
	}
}
