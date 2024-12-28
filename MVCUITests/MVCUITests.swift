import XCTest

final class MVCUITests: XCTestCase {
    private var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["-ui-testing"]
        app.launchEnvironment = ["-networking-success": "1"]
        app.launch()
        XCUIDevice.shared.orientation = .portrait
        XCUIDevice.shared.appearance = .dark
    }

    override func tearDown() {
        super.tearDown()
        app = nil
    }

    func testSearchMarvelCharacter() {
        let marvelsNavigationBar = app.navigationBars["Marvels"]
        XCTAssertTrue(marvelsNavigationBar.exists)
        XCTAssertTrue(marvelsNavigationBar.waitForExistence(timeout: 1))

        let table = app.tables
        waitForTableViewToFill(element: table.cells)
        XCTAssertGreaterThan(table.cells.count, 0)

        let enterMarvelNameSearchField = marvelsNavigationBar.searchFields.element
        enterMarvelNameSearchField.tap()
        enterMarvelNameSearchField.typeText("Bomb")
        XCTAssertEqual(table.cells.count, 1)

        table.cells.firstMatch.tap()
        let detailNavigationBar = app.navigationBars["A-Bomb (HAS)"]
        XCTAssertTrue(app.staticTexts["A-Bomb (HAS)"].exists)

        app.navigationBars.element.buttons["Marvels"].tap()
        marvelsNavigationBar.buttons["Cancel"].tap()
        XCTAssertFalse(detailNavigationBar.exists)
    }

    func testThirdMarvelCharacterTap() {
        waitForTableViewToFill(element: app.tables.cells)
        let cells = app.tables.children(matching: .cell)
        let anotherWayToGetCells = app.tables.cells
        XCTAssertEqual(cells.count, 20)
        XCTAssertEqual(anotherWayToGetCells.count, 20)

        let thirdCell = cells.element(boundBy: 2)
        thirdCell.tap()
        let navigationBar = app.navigationBars.staticTexts["A.I.M."]
        let anotherWaytToGetNavigationBar = app.navigationBars.element
        XCTAssertTrue(navigationBar.exists)
        XCTAssertEqual(anotherWaytToGetNavigationBar.staticTexts.element.label, "A.I.M.")

        //Accessing through accessibilityIdentifier
        let nameLabel = app.staticTexts["marvelCharacterName"]
        XCTAssertTrue(nameLabel.exists, "Name Label is missing")
        XCTAssertEqual(nameLabel.label, "A.I.M.")
    }

    func testSpecificMarvelCharacterTap() {
        let marvelsNavigationBar = app.navigationBars["Marvels"]
        XCTAssertTrue(marvelsNavigationBar.exists)

        let table = app.tables
        waitForTableViewToFill(element: table.cells)
        table.cells.staticTexts["A-Bomb (HAS)"].tap()
        let detailNavigationBar = app.navigationBars["A-Bomb (HAS)"]
        XCTAssertTrue(app.staticTexts["A-Bomb (HAS)"].exists)

        app.navigationBars["A-Bomb (HAS)"].buttons["Marvels"].tap()
        XCTAssertFalse(detailNavigationBar.exists)
    }

    @MainActor
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}

extension MVCUITests {
    private func waitForTableViewToFill(element: XCUIElementQuery,
                                        file: String = #file,
                                        line: UInt = #line) {
        let existsPredicate = NSPredicate(format: "count > 1")
        expectation(for: existsPredicate, evaluatedWith: element, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
    }
}
