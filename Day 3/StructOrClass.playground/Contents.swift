import UIKit

//1. STRUCT (Value Type)
struct Employee {
    var name: String?
}
// Create the original struct instance
var emp1 = Employee(name: "Ashish")
// Copying a struct creates
var emp2 = emp1
// Modify the copy
emp2.name = "Jhon"

// Verification: The original remains completely unchanged!
print(emp1.name ?? "")
print(emp2.name ?? "")

// 2. CLASS (Reference Type)
class User {
    var email: String?
    // Classes require an explicit initializer (structs get one automatically)
    init(email: String) {
        self.email = email
    }
}
// Create the original class instance
var userData = User(email: "ash@gmail.com")

// Copying a class copies the memory address pointer, NOT the data itself
var userData2 = userData

// Modify the copy
userData2.email = "abc@gmail.com"

// Verification: BOTH names changed because they point to the exact same object!
print(userData.email ?? "")
print(userData2.email ?? "")
