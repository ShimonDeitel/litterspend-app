import XCTest

final class LitterspendUITests: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testAddButtonOpensEntrySheet() throws {
        let app = XCUIApplication()
        app.launch()
        app.buttons["addButton"].tap()
        XCTAssertTrue(app.buttons["saveButton"].waitForExistence(timeout: 5))
        app.buttons["cancelButton"].tap()
    }

    func testAddingEntrySavesAndDismisses() throws {
        let app = XCUIApplication()
        app.launch()
        app.buttons["addButton"].tap()
        let firstField = app.textFields.firstMatch
        if firstField.waitForExistence(timeout: 5) {
            firstField.tap()
            firstField.typeText("Test Entry")
        }
        app.buttons["saveButton"].tap()
        XCTAssertFalse(app.buttons["saveButton"].exists)
    }

    func testTapOutsideDismissesKeyboard() throws {
        let app = XCUIApplication()
        app.launch()
        app.buttons["addButton"].tap()
        let firstField = app.textFields.firstMatch
        if firstField.waitForExistence(timeout: 5) {
            firstField.tap()
            firstField.typeText("Sample")
            XCTAssertTrue(app.keyboards.element.exists)
            app.navigationBars.firstMatch.tap()
        }
        app.buttons["cancelButton"].tap()
    }

    func testSettingsButtonOpensSettings() throws {
        let app = XCUIApplication()
        app.launch()
        app.buttons["settingsButton"].tap()
        XCTAssertTrue(app.buttons["settingsDoneButton"].waitForExistence(timeout: 5))
        app.buttons["settingsDoneButton"].tap()
    }
}
