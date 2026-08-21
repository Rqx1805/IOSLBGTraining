import Foundation

// MARK: - CLASS (Reference Type)

final class User {

    // Non-optional because email is required during initialization
    var email: String

    init(email: String) {
        self.email = email
    }
}


// MARK: - Reference Type Example

// Use let because the instance reference itself does not need reassignment
let userEmail = User(email: "ash@gmail.com")

// Both variables point to the same User instance
let secondUserEmail = userEmail

// Modifying the object's property is still allowed
secondUserEmail.email = "abc@gmail.com"

// Both print the updated value because User is a reference type
print(userEmail.email)
print(secondUserEmail.email)


// MARK: - Real iOS Example — MVVM

final class UserViewModel {

    private(set) var users: [User] = []

    func updateUsers(_ users: [User]) {
        self.users = users
    }
}
