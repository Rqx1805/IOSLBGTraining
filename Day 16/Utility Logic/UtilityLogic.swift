struct EmailValidator {

    func isValid(_ email: String) -> Bool {

        let trimmedEmail =
            email.trimmingCharacters(
                in: .whitespacesAndNewlines
            )

        guard !trimmedEmail.isEmpty else {
            return false
        }

        guard trimmedEmail.contains("@") else {
            return false
        }

        guard trimmedEmail.contains(".") else {
            return false
        }

        return true
    }
}


import XCTest

final class EmailValidatorTests: XCTestCase {

    private let validator =
        EmailValidator()

    func testValidEmailReturnsTrue() {

        // Arrange
        let email =
            "ashish@example.com"

        // Act
        let result =
            validator.isValid(email)

        // Assert
        XCTAssertTrue(result)
    }

    func testEmailWithoutAtSymbolReturnsFalse() {

        let email =
            "ashish.example.com"

        let result =
            validator.isValid(email)

        XCTAssertFalse(result)
    }

    func testEmailWithoutDomainExtensionReturnsFalse() {

        let email =
            "ashish@example"

        let result =
            validator.isValid(email)

        XCTAssertFalse(result)
    }

    func testEmptyEmailReturnsFalse() {

        let result =
            validator.isValid("")

        XCTAssertFalse(result)
    }

    func testWhitespaceEmailReturnsFalse() {

        let result =
            validator.isValid("   ")

        XCTAssertFalse(result)
    }
}
