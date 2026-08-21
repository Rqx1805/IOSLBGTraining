import UIKit

// CLASS (Reference Type)
class User {
    var email: String?
    // Classes require an explicit initializer (structs get one automatically)
    init(email: String) {
        self.email = email
    }
}
// Create the original class instance
var userEmail = User(email: "ash@gmail.com")

// Copying a class copies the memory address pointer, NOT the data itself
var secondUserEmail = userEmail

// Modify the copy
secondUserEmail.email = "abc@gmail.com"

// Verification: BOTH names changed because they point to the exact same object!
print(userEmail.email ?? "")
print(secondUserEmail.email ?? "")

// Real iOS example — MVVM
// ViewModel → Class
final class UserViewModel {

    private(set) var users: [User] = []

    func updateUsers(_ users: [User]) {
        self.users = users
    }
}

