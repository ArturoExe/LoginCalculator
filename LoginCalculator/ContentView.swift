import SwiftUI

// MARK: - ContentView
// This is the main screen used for UI Testing demos.
// It contains:
//   • Two TextFields (username + password)
//   • A Login button
//   • A result label that changes based on input
//
// Each element has an .accessibilityIdentifier so UI tests
// can find them reliably without depending on display text.

struct ContentView: View {

    // MARK: State
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var message: String = ""
    @State private var isLoggedIn: Bool = false
    @State private var showCalculator: Bool = false

    // MARK: Body
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {

                // ── App header ──────────────────────────────────────
                Image(systemName: "person.circle.fill")
                    .font(.system(size: 72))
                    .foregroundStyle(.blue)
                    .accessibilityIdentifier("appIcon")

                Text("UI Testing Demo")
                    .font(.largeTitle.bold())

                // ── Input fields ────────────────────────────────────
                VStack(spacing: 16) {

                    // TextField 1: Username
                    TextField("Username", text: $username)
                        .textFieldStyle(.roundedBorder)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        // 👉 accessibilityIdentifier is the key for UI tests:
                        //    app.textFields["usernameField"]
                        .accessibilityIdentifier("usernameField")

                    // TextField 2: Password
                    SecureField("Password", text: $password)
                        .textFieldStyle(.roundedBorder)
                        // 👉 app.secureTextFields["passwordField"]
                        .accessibilityIdentifier("passwordField")
                }
                .padding(.horizontal)

                // ── Primary button ──────────────────────────────────
                Button(action: handleLogin) {
                    Text("Log In")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(isFormValid ? Color.blue : Color.gray)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .disabled(!isFormValid)
                .padding(.horizontal)
                // 👉 app.buttons["loginButton"]
                .accessibilityIdentifier("loginButton")

                // ── Result / feedback label ─────────────────────────
                // This label changes text based on login outcome.
                // UI tests can assert on its content.
                if !message.isEmpty {
                    Text(message)
                        .font(.headline)
                        .foregroundStyle(isLoggedIn ? .green : .red)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                        // 👉 app.staticTexts["resultLabel"]
                        .accessibilityIdentifier("resultLabel")
                        .transition(.opacity)
                }

                // ── Navigation to second screen ─────────────────────
                if isLoggedIn {
                    NavigationLink("Go to Calculator", destination: CalculatorView())
                        .buttonStyle(.borderedProminent)
                        // 👉 app.buttons["goToCalculatorButton"]
                        .accessibilityIdentifier("goToCalculatorButton")
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }

                Spacer()
            }
            .padding(.top, 40)
            .navigationTitle("")
            .animation(.easeInOut, value: message)
            .animation(.easeInOut, value: isLoggedIn)
        }
    }

    // MARK: Helpers

    /// Basic validation: both fields must have at least 3 characters.
    var isFormValid: Bool {
        username.count >= 3 && password.count >= 3
    }

    /// Simulates a login check.
    /// Correct credentials → admin / secret123
    func handleLogin() {
        if username == "admin" && password == "secret123" {
            message = "Welcome, \(username)! 🎉"
            isLoggedIn = true
        } else {
            message = "Invalid username or password."
            isLoggedIn = false
        }
    }
}

// MARK: - Preview
#Preview {
    ContentView()
}
