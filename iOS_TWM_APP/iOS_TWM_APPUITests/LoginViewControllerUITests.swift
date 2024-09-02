import XCTest

class LoginViewControllerUITests: XCTestCase {

    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
    }
    
    func testLoginButtonEnabledWhenTextFieldsAreFilled() {
        let userIDTextField = app.textFields["userIDTextField"]
        let passwordTextField = app.secureTextFields["passwordTextField"]
        let signinButton = app.buttons["signinButton"]
      
            
        userIDTextField.tap()
        userIDTextField.typeText("testUser")
        
        passwordTextField.tap()
        passwordTextField.typeText("testPassword")
        
        let doneButton = app.buttons["Done"]
            doneButton.tap()
        
        
        signinButton.tap()

    }
    
    func testLoginProcess() {
        let userIDTextField = app.textFields["userIDTextField"]
        let passwordTextField = app.secureTextFields["passwordTextField"]
        let loginButton = app.buttons["loginButton"]
        let doneButton = app.buttons["Done"]

        userIDTextField.tap()
        userIDTextField.typeText("testUser")
        doneButton.tap()

        passwordTextField.tap()
        passwordTextField.typeText("testPassword")
        
        doneButton.tap()
        
        loginButton.tap()
        
        let mapView = app.otherElements["MapView"]
        let exists = mapView.waitForExistence(timeout: 5)

        
        XCTAssertTrue(app.otherElements["MapView"].exists)
    }
    
    func testRememberLoginStateCheckbox() {
        let checkButton = app.buttons["checkButton"]
        
        checkButton.tap()
    }
    
    func testTotal() {
   
        let doneButton = app.buttons["Done"]

        testLoginButtonEnabledWhenTextFieldsAreFilled()
        //testRememberLoginStateCheckbox()

        app.textFields["userIDTextField"].clearAndEnterText(text: "testUser")
        doneButton.tap()
        app.secureTextFields["passwordTextField"].clearAndEnterText(text: "***********")

        testLoginProcess()
        sleep(5)
    }
}


extension XCUIElement {
    /**
     Removes any current text in the field before typing in the new value
     - Parameter text: the text to enter into the field
     */
    func clearAndEnterText(text: String) {
        guard let stringValue = self.value as? String else {
            XCTFail("Tried to clear and enter text into a non string value")
            return
        }

        self.tap()

        let deleteString = String(repeating: XCUIKeyboardKey.delete.rawValue, count: stringValue.count)

        self.typeText(deleteString)
    }
}
