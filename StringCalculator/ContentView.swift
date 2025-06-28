//
//  ContentView.swift
//  StringCalculator
//
//  Created by Mohammed Saqib on 29/06/25.
//

import SwiftUI

struct ContentView: View {
	@StateObject var calculatorVM = CalculatorAppViewModel()
	@State private var numbers: String = ""
	@State private var showAlert: Bool = false
	@State private var errorMessage: String = ""
	
	@State private var rotationAngle: Double = 0
	
	var body: some View {
		
		VStack(spacing: 20) {
			Text("String Calculator")
				.font(.largeTitle)
				.bold()
				.foregroundStyle(.gray)
				.padding()
			
			TextField("Enter numbers", text: $numbers)
				.textFieldStyle(.roundedBorder)
				.padding(.horizontal)
				.font(.title2)
				.fontWeight(.regular)
			
			Button {
				rotateButton()
				calculateSum()
			} label: {
				Text("=")
					.font(.largeTitle)
					.frame(width: 50, height: 50)
					.padding()
					.background(Color.orange)
					.foregroundStyle(.white)
					.clipShape(.circle)
			}
			.rotationEffect(.degrees(rotationAngle))
			.padding(.horizontal)
		}
		.padding()
		.alert(isPresented: $showAlert, content: {
			Alert(title: Text("Error"),
				  message: Text(errorMessage),
				  dismissButton: .default(Text("Ok")))
		})
	}
	
	private func calculateSum() {
		do {
			let sum = try calculatorVM.add(numbers)
			numbers = "\(sum)"
			errorMessage = ""
		} catch {
			errorMessage = "\(error)"
			showAlert = true
		}
	}
	
	private func rotateButton() {

		withAnimation(.easeInOut(duration: 0.8)) {
			rotationAngle += 360
		}
	}
}

#Preview {
	ContentView()
}
