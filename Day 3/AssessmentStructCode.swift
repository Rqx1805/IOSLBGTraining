// MARK: - STRUCT (VALUE TYPE)
//
// A struct is a VALUE TYPE.
//
// When a struct is assigned to another variable,
// the new variable gets its own independent value.
//
// Common value types:
// - Struct
// - Enum
// - Tuple
//
// Structs are commonly used for:
// - API Models
// - Data objects
// - View state
// - Configuration
// - Lightweight types
//
// Struct:
// 1. Value type
// 2. Independent copies
// 3. No inheritance
// 4. Does not use ARC for the struct itself
// 5. Supports mutating methods
// 6. No deinit
// 7. Good for data/models
// 8. Provides value semantics


// MARK: - 1. Basic Struct

struct Employee {

    var name: String
    var age: Int
}


// MARK: - 2. Create Struct Instance

var employee = Employee(
    name: "Ashish",
    age: 30
)

print("Employee:")
print(employee.name)
print(employee.age)


// MARK: - 3. Value Type / Independent Copy

// A struct is a value type.
//
// employeeCopy gets an independent value.
// It does NOT point to the same object.

var employeeCopy = employee


// Modify the copy

employeeCopy.name = "John"
employeeCopy.age = 25


// Original remains unchanged

print("\nOriginal Employee:")
print(employee.name)
print(employee.age)

print("\nCopied Employee:")
print(employeeCopy.name)
print(employeeCopy.age)


// Output:
//
// Original Employee:
// Ashish
// 30
//
// Copied Employee:
// John
// 25


// MARK: - 4. Mutating Method
//
// Struct methods cannot modify stored properties
// unless the method is marked with `mutating`.

struct Counter {

    var value: Int = 0

    mutating func increment() {
        value += 1
    }

    mutating func decrement() {
        value -= 1
    }
}


var counter = Counter()

counter.increment()
counter.increment()
counter.increment()

print("\nCounter:")
print(counter.value) // 3

counter.decrement()

print(counter.value) // 2


// MARK: - 5. API Model
//
// Structs are commonly used for API response models
// because API data usually represents values/data
// rather than an object with identity or lifecycle.

struct User: Codable {

    let id: Int
    let name: String
    let email: String
}


// MARK: - 6. Create User Model

let user = User(
    id: 1,
    name: "Ashish",
    email: "ashish@example.com"
)

print("\nUser:")
print("ID: \(user.id)")
print("Name: \(user.name)")
print("Email: \(user.email)")


// MARK: - 7. Struct Copy Example

let originalUser = User(
    id: 1,
    name: "Ashish",
    email: "ashish@example.com"
)

let copiedUser = originalUser

print("\nAre the values equal?")

print(originalUser.id == copiedUser.id)       // true
print(originalUser.name == copiedUser.name)   // true
print(originalUser.email == copiedUser.email) // true


// MARK: - 8. Enum is also a Value Type

enum AccountType {
    case savings
    case current
    case salary
}

let accountType = AccountType.salary

print("\nAccount Type:")
print(accountType)


// MARK: - 9. Tuple is also a Value Type

let employeeInfo = (
    name: "Ashish",
    department: "iOS",
    experience: 8
)

print("\nEmployee Information:")
print(employeeInfo.name)
print(employeeInfo.department)
print(employeeInfo.experience)


// MARK: - 10. Struct as View State
//
// Structs are useful for representing UI state.
//
// Example:
// Loading
// Success
// Error

enum ViewState {
    case loading
    case success
    case error
}

struct UserViewState {

    var state: ViewState
    var users: [User]
}


// Example View State

var viewState = UserViewState(
    state: .loading,
    users: []
)

print("\nInitial View State:")
print(viewState.users.count)


// Update the value

viewState.state = .success

viewState.users = [
    User(
        id: 1,
        name: "Ashish",
        email: "ashish@example.com"
    ),
    User(
        id: 2,
        name: "Rahul",
        email: "rahul@example.com"
    )
]

print("\nUpdated View State:")
print(viewState.users.count)


// MARK: - 11. Struct as Configuration

struct AppConfiguration {

    let baseURL: String
    let timeout: TimeInterval
    let isDebug: Bool
}


let configuration = AppConfiguration(
    baseURL: "https://api.example.com",
    timeout: 30,
    isDebug: true
)

print("\nApp Configuration:")
print(configuration.baseURL)
print(configuration.timeout)
print(configuration.isDebug)


// MARK: - IMPORTANT DIFFERENCE
//
// Struct:
//
// Value Type
//      ↓
// Independent Copy
//
// Class:
//
// Reference Type
//      ↓
// Same Object Can Be Shared
//
//
// Example:
//
// STRUCT

var employee1 = Employee(
    name: "Ashish",
    age: 30
)

var employee2 = employee1

employee2.name = "John"

print("\nStruct Example:")
print(employee1.name) // Ashish
print(employee2.name) // John


// CLASS

class EmployeeClass {

    var name: String

    init(name: String) {
        self.name = name
    }
}

var employeeClass1 = EmployeeClass(name: "Ashish")
var employeeClass2 = employeeClass1

employeeClass2.name = "John"

print("\nClass Example:")
print(employeeClass1.name) // John
print(employeeClass2.name) // John
