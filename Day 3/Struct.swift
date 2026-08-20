import UIKit

// STRUCT (Value Type)
struct Employee {
    var name: String?
}
// Create the original struct instance
var employee = Employee(name: "Ashish")
// Copying a struct creates
var otherEmployee = employee
// Modify the copy
otherEmployee.name = "Jhon"

// Verification: The original remains completely unchanged!
print(employee.name ?? "")
print(otherEmployee.name ?? "")
