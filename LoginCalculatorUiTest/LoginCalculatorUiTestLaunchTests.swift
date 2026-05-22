//
//  LoginCalculatorUiTestLaunchTests.swift
//  LoginCalculatorUiTest
//
//  Created by Arturo Martinez on 5/21/26.
//
 
// MARK: - UITestingDemoUITests
//
// This file teaches the core concepts of SwiftUI UI Testing.
// Each test is grouped by concept with explanations.
//
// HOW TO RUN:
//   • Single test: click the diamond ◆ next to a test function
//   • All tests:   Product > Test  (⌘U)
//
// KEY CONCEPTS COVERED:
//   1. Finding elements (textFields, buttons, staticTexts)
//   2. Typing into text fields
//   3. Tapping buttons
//   4. Asserting element existence
//   5. Asserting element values / labels
//   6. Waiting for elements (async UI)
//   7. Testing navigation between screens

import XCTest
@testable import LoginCalculator

final class LoginCalculatorUiTestLaunchTests: XCTestCase {

    // MARK: - Setup & Teardown
     
        // `app` is the handle to your running application.
        // XCUIApplication wraps the entire UI hierarchy.
        var app: XCUIApplication!
     
        override func setUpWithError() throws {
            // Stop immediately when a failure occurs.
            // This prevents misleading cascading failures.
            continueAfterFailure = false
     
            app = XCUIApplication()
     
            // You can pass launch arguments to the app,
            // useful for enabling a test/mock mode.
            // app.launchArguments = ["--uitesting"]
     
            app.launch()
        }
     
        override func tearDownWithError() throws {
            // Runs after every test.
            // Good place to take screenshots on failure, reset state, etc.
            app = nil
        }
    
    
    
        // MARK: - Concept 1: Finding Elements
        // ─────────────────────────────────────────────────────────────
        // XCUIApplication lets you query elements by type and identifier.
        // Common queries:
        //   app.textFields["id"]        → UITextField
        //   app.secureTextFields["id"]  → UITextField (password)
        //   app.buttons["id"]           → UIButton
        //   app.staticTexts["id"]       → UILabel / Text view
     
        func test_01_elementsExist() throws {
            // XCTAssert* functions are how you make assertions in XCTest.
     
            // Check the username field is on screen
            XCTAssertTrue(app.textFields["usernameField"].exists,
                          "Username field should be visible")
     
            // Check the password field is on screen
            XCTAssertTrue(app.secureTextFields["passwordField"].exists,
                          "Password field should be visible")
     
            // Check the login button is on screen
            XCTAssertTrue(app.buttons["loginButton"].exists,
                          "Login button should be visible")
        }
     
     
        // MARK: - Concept 2: Typing into Text Fields
     
        func test_02_canTypeIntoFields() throws {
            let usernameField = app.textFields["usernameField"]
            let passwordField = app.secureTextFields["passwordField"]
     
            // .tap() focuses the element (brings up keyboard, etc.)
            usernameField.tap()
     
            // .typeText() simulates keyboard input character by character.
            usernameField.typeText("admin")
     
            passwordField.tap()
            passwordField.typeText("secret123")
     
            // Verify the username field has the correct value.
            // Note: secureTextFields don't expose their value for security.
            XCTAssertEqual(usernameField.value as? String, "admin")
        }
     
     
        // MARK: - Concept 3: Tapping Buttons
     
        func test_03_loginButtonDisabledWhenFieldsEmpty() throws {
            let loginButton = app.buttons["loginButton"]
     
            // isEnabled reflects whether the button is interactive.
            // Our button is disabled when inputs are too short.
            XCTAssertFalse(loginButton.isEnabled,
                           "Login button should be disabled with empty fields")
        }
     
        func test_04_loginButtonEnabledAfterValidInput() throws {
            app.textFields["usernameField"].tap()
            app.textFields["usernameField"].typeText("admin")
     
            app.secureTextFields["passwordField"].tap()
            app.secureTextFields["passwordField"].typeText("secret123")
     
            XCTAssertTrue(app.buttons["loginButton"].isEnabled,
                          "Login button should enable once fields have content")
        }
     
     
        // MARK: - Concept 4: Asserting on Labels (staticTexts)
     
        func test_05_successMessageAppearsOnCorrectLogin() throws {
            // Type correct credentials
            app.textFields["usernameField"].tap()
            app.textFields["usernameField"].typeText("admin")
     
            app.secureTextFields["passwordField"].tap()
            app.secureTextFields["passwordField"].typeText("secret123")
     
            // Tap the login button
            app.buttons["loginButton"].tap()
     
            // Assert the result label shows the welcome message.
            // staticTexts["id"] finds a Text/Label by its accessibilityIdentifier.
            let resultLabel = app.staticTexts["resultLabel"]
            XCTAssertTrue(resultLabel.exists, "Result label should appear after login")
     
            // Check the exact text content
            XCTAssertTrue(resultLabel.label.contains("Welcome"),
                          "Success message should contain 'Welcome'")
        }
     
        func test_06_errorMessageAppearsOnWrongCredentials() throws {
            app.textFields["usernameField"].tap()
            app.textFields["usernameField"].typeText("wronguser")
     
            app.secureTextFields["passwordField"].tap()
            app.secureTextFields["passwordField"].typeText("wrongpass")
     
            app.buttons["loginButton"].tap()
     
            let resultLabel = app.staticTexts["resultLabel"]
            XCTAssertTrue(resultLabel.exists)
            XCTAssertTrue(resultLabel.label.contains("Invalid"),
                          "Error message should say 'Invalid'")
        }
     
     
        // MARK: - Concept 5: Waiting for Elements (Async UI)
        // ─────────────────────────────────────────────────────────────
        // Some elements appear after a delay (animations, network calls).
        // Use XCTNSPredicateExpectation + waitForExpectations to handle this.
     
        func test_07_waitForElementToAppear() throws {
            app.textFields["usernameField"].tap()
            app.textFields["usernameField"].typeText("admin")
            app.secureTextFields["passwordField"].tap()
            app.secureTextFields["passwordField"].typeText("secret123")
            app.buttons["loginButton"].tap()
     
            // Create a predicate: "this element exists"
            let resultLabel = app.staticTexts["resultLabel"]
            let predicate = NSPredicate(format: "exists == true")
            let expectation = XCTNSPredicateExpectation(predicate: predicate,
                                                         object: resultLabel)
     
            // Wait up to 3 seconds for the label to appear.
            // Fails the test if the element never satisfies the predicate.
            let result = XCTWaiter.wait(for: [expectation], timeout: 3.0)
            XCTAssertEqual(result, .completed, "Result label should appear within 3 seconds")
        }
     
     
        // MARK: - Concept 6: Testing Navigation
     
        func test_08_navigateToCalculatorAfterLogin() throws {
            // Log in first
            app.textFields["usernameField"].tap()
            app.textFields["usernameField"].typeText("admin")
            app.secureTextFields["passwordField"].tap()
            app.secureTextFields["passwordField"].typeText("secret123")
            app.buttons["loginButton"].tap()
     
            // Wait for the navigation button to appear
            let navButton = app.buttons["goToCalculatorButton"]
            XCTAssertTrue(navButton.waitForExistence(timeout: 2),
                          "Navigation button should appear after successful login")
     
            // Tap it to navigate
            navButton.tap()
     
            // Verify we're on the Calculator screen by checking its elements
            XCTAssertTrue(app.textFields["firstNumberField"].waitForExistence(timeout: 2),
                          "Should have navigated to Calculator screen")
        }
     
     
        // MARK: - Concept 7: Full Flow — Calculator
     
        func test_09_calculatorAddsNumbers() throws {
            // Navigate to calculator (reuse login flow)
            loginAndNavigateToCalculator()
     
            // Enter numbers
            let firstField = app.textFields["firstNumberField"]
            firstField.tap()
            firstField.typeText("8")
     
            let secondField = app.textFields["secondNumberField"]
            secondField.tap()
            secondField.typeText("4")
     
            // Tap Add button
            app.buttons["addButton"].tap()
     
            // Assert result
            let resultLabel = app.staticTexts["calculatorResult"]
            XCTAssertTrue(resultLabel.waitForExistence(timeout: 2))
            XCTAssertTrue(resultLabel.label.contains("12"),
                          "8 + 4 should equal 12")
        }
     
        func test_10_calculatorDivisionByZeroShowsError() throws {
            loginAndNavigateToCalculator()
     
            app.textFields["firstNumberField"].tap()
            app.textFields["firstNumberField"].typeText("5")
     
            app.textFields["secondNumberField"].tap()
            app.textFields["secondNumberField"].typeText("0")
     
            app.buttons["divideButton"].tap()
     
            let resultLabel = app.staticTexts["calculatorResult"]
            XCTAssertTrue(resultLabel.waitForExistence(timeout: 2))
            XCTAssertTrue(resultLabel.label.contains("zero"),
                          "Should display a divide by zero error")
        }
     
     
        // MARK: - Private Helpers
        // Extract repeated flows into helper methods to keep tests clean.
     
        private func loginAndNavigateToCalculator() {
            app.textFields["usernameField"].tap()
            app.textFields["usernameField"].typeText("admin")
            app.secureTextFields["passwordField"].tap()
            app.secureTextFields["passwordField"].typeText("secret123")
            app.buttons["loginButton"].tap()
     
            let navButton = app.buttons["goToCalculatorButton"]
            _ = navButton.waitForExistence(timeout: 2)
            navButton.tap()
     
            _ = app.textFields["firstNumberField"].waitForExistence(timeout: 2)
        }
    @MainActor
    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        // Insert steps here to perform after app launch but before taking a screenshot,
        // such as logging into a test account or navigating somewhere in the app

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
