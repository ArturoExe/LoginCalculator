//
//  CalculatorView.swift
//  LoginCalculator
//
//  Created by Arturo Martinez on 5/21/26.
//


import SwiftUI

// MARK: - CalculatorView
// A second screen used to demonstrate:
//   • Navigation in UI tests
//   • Testing computed/dynamic results
//   • Interacting with multiple inputs and a result label

struct CalculatorView: View {

    // MARK: State
    @State private var firstNumber: String = ""
    @State private var secondNumber: String = ""
    @State private var result: String = ""

    // MARK: Body
    var body: some View {
        VStack(spacing: 24) {

            Image(systemName: "plus.forwardslash.minus")
                .font(.system(size: 60))
                .foregroundStyle(.indigo)

            Text("Simple Calculator")
                .font(.title.bold())

            // ── Number inputs ────────────────────────────────────
            VStack(spacing: 16) {

                // Input A
                TextField("First number", text: $firstNumber)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.decimalPad)
                    // 👉 app.textFields["firstNumberField"]
                    .accessibilityIdentifier("firstNumberField")

                // Input B
                TextField("Second number", text: $secondNumber)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.decimalPad)
                    // 👉 app.textFields["secondNumberField"]
                    .accessibilityIdentifier("secondNumberField")
            }
            .padding(.horizontal)

            // ── Operation buttons ────────────────────────────────
            HStack(spacing: 16) {
                OperationButton(label: "+", id: "addButton")    { calculate(.add) }
                OperationButton(label: "−", id: "subtractButton") { calculate(.subtract) }
                OperationButton(label: "×", id: "multiplyButton") { calculate(.multiply) }
                OperationButton(label: "÷", id: "divideButton")   { calculate(.divide) }
            }
            .padding(.horizontal)

            // ── Result label ─────────────────────────────────────
            // UI tests assert that after tapping a button,
            // this label shows the expected value.
            if !result.isEmpty {
                Text("Result: \(result)")
                    .font(.title2.bold())
                    .padding()
                    .background(Color.indigo.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    // 👉 app.staticTexts["calculatorResult"]
                    .accessibilityIdentifier("calculatorResult")
                    .transition(.scale.combined(with: .opacity))
            }

            Spacer()
        }
        .padding(.top, 32)
        .navigationTitle("Calculator")
        .navigationBarTitleDisplayMode(.inline)
        .animation(.spring(), value: result)
    }

    // MARK: Helpers

    enum Operation { case add, subtract, multiply, divide }

    func calculate(_ op: Operation) {
        guard let a = Double(firstNumber), let b = Double(secondNumber) else {
            result = "Enter valid numbers"
            return
        }
        let value: Double
        switch op {
        case .add:      value = a + b
        case .subtract: value = a - b
        case .multiply: value = a * b
        case .divide:
            guard b != 0 else { result = "Cannot divide by zero"; return }
            value = a / b
        }
        // Format: show as Int when possible, otherwise 2 decimal places
        result = value.truncatingRemainder(dividingBy: 1) == 0
            ? String(Int(value))
            : String(format: "%.2f", value)
    }
}

// MARK: - OperationButton
// Small reusable button with a required accessibilityIdentifier.
struct OperationButton: View {
    let label: String
    let id: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.title.bold())
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(Color.indigo)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .accessibilityIdentifier(id)
    }
}

// MARK: - Preview
#Preview {
    NavigationStack { CalculatorView() }
}