import Foundation
import XCTest

final class SettingsScreen: BaseScreen {

    struct ElementStringIDs {
        static let headlineLabel = "headline-label"
        static let bodyLabel = "body-label"
        static let logOutButton = "settings-log-out-button"
    }

    private let selectedSiteUrl = XCUIApplication().cells.staticTexts[ElementStringIDs.headlineLabel]
    private let selectedDisplayName = XCUIApplication().cells.staticTexts[ElementStringIDs.bodyLabel]
    private let logOutButton = XCUIApplication().cells[ElementStringIDs.logOutButton]
    private let logOutAlert = XCUIApplication().alerts.element(boundBy: 0)

    init() {
        super.init(element: logOutButton)

        XCTAssert(logOutButton.waitForExistence(timeout: 3))
    }

    @discardableResult
    func goBackToMyStore() -> MyStoreScreen {
        navBackButton.tap()
        return MyStoreScreen()
    }

    @discardableResult
    func logOut() -> PrologueScreen {
        logOutButton.tap()

        // Some localizations have very long "log out" text, which causes the UIAlertView
        // to stack. We need to detect these cases in order to reliably tap the correct button
        if logOutAlert.buttons.allElementsShareCommonXAxis {
            logOutAlert.buttons.element(boundBy: 0).tap()
        }
        else {
            logOutAlert.buttons.element(boundBy: 1).tap()
        }

        return PrologueScreen()
    }
}

/// Assertions
extension SettingsScreen {

    func verifySelectedStoreDisplays(siteUrl expectedSiteUrl: String, displayName expectedDisplayName: String) -> SettingsScreen {
        let expectedSiteUrl = expectedSiteUrl.replacingOccurrences(of: "http://", with: "")
        let actualSiteUrl = selectedSiteUrl.label
        let actualDisplayName = selectedDisplayName.label

        XCTAssertEqual(expectedSiteUrl, actualSiteUrl,
                       "Expected site URL \(expectedSiteUrl) but \(actualSiteUrl) was displayed instead.")
        XCTAssertEqual(expectedDisplayName, actualDisplayName,
                       "Expected display name '\(expectedDisplayName)' but '\(actualDisplayName)' was displayed instead.")

        return self
    }
}
