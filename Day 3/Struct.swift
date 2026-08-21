// MARK: - STRUCT (Value Type)

struct Employee {

    // No need for Optional because name
    // is expected to always have a value.
    var name: String
}


// MARK: - Create Original Struct Instance

var employee = Employee(name: "Ashish")


// MARK: - Copying a Struct

// Structs are Value Types.
// A new independent copy is created.

var otherEmployee = employee


// MARK: - Modify the Copy

otherEmployee.name = "John"


// MARK: - Verification

// Original remains unchanged
print(employee.name)

// Copy contains the modified value
print(otherEmployee.name)


// Output:
// Ashish
// John


// MARK: - Real iOS Example — MVVM

// Model → Struct

struct User: Codable {

    let id: Int
    let name: String
    let email: String
}


// MARK: - Example User

let user = User(
    id: 1,
    name: "Ashish",
    email: "ashish@example.com"
)

print(user.name)
print(user.email)
