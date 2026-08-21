import Foundation

// MARK: - ARC
//
// ARC = Automatic Reference Counting
//
// ARC manages memory for CLASS instances.
//
// ARC keeps track of STRONG references.
//
// When the strong reference count becomes ZERO,
// the class instance is deallocated and `deinit` is called.


// MARK: - 1. Strong Reference
//
// Strong reference:
// - Keeps the object alive
// - Default reference type for class properties/variables
//
// Example:
//
// var customer = Customer(...)
//
// `customer` strongly references the Customer object.


class Customer {

    // `let` because name is assigned only once
    // and never changed.
    let name: String

    init(name: String) {
        self.name = name
        print("\(name) - Customer Initialized")
    }

    deinit {
        print("\(name) - Customer Deallocated")
    }
}


// Create first strong reference
var firstCustomer: Customer? = Customer(name: "David")

// Strong Reference Count = 1


// Create second strong reference
var secondCustomer = firstCustomer

// Strong Reference Count = 2
//
// firstCustomer ────┐
//                    ↓
//                 Customer
//                    ↑
// secondCustomer ────┘


// Remove first strong reference
firstCustomer = nil

// Strong Reference Count = 1
//
// Object is still alive because
// secondCustomer is still holding it.


// Remove second strong reference
secondCustomer = nil

// Strong Reference Count = 0
//
// Customer is deallocated.
//
// `deinit` is called.
//
// Output:
// David - Customer Deallocated



// MARK: - 2. Retain Cycle
//
// Retain cycle:
// Two or more objects strongly hold each other.
//
// Example:
//
// Employee ──strong──→ Department
//    ↑                    |
//    |                    |
//    └────strong──────────┘
//
// Both objects keep each other alive.
//
// Therefore ARC cannot deallocate them.


class Employee {

    let name: String

    var department: Department?

    init(name: String) {
        self.name = name
        print("\(name) - Employee Initialized")
    }

    deinit {
        print("\(name) - Employee Deallocated")
    }
}


class Department {

    let name: String

    var employee: Employee?

    init(name: String) {
        self.name = name
        print("\(name) - Department Initialized")
    }

    deinit {
        print("\(name) - Department Deallocated")
    }
}


// Create Employee
var employee: Employee? = Employee(name: "Jack")


// Create Department
var department: Department? =
    Department(name: "Development")


// Employee strongly holds Department
employee?.department = department


// Department strongly holds Employee
department?.employee = employee


// Retain cycle:
//
// Employee
//    |
//    | strong
//    ↓
// Department
//    |
//    | strong
//    ↓
// Employee


// Remove external references
employee = nil
department = nil


// IMPORTANT:
//
// Neither object is deallocated.
//
// Why?
//
// Employee still strongly references Department.
// Department still strongly references Employee.
//
// This is a RETAIN CYCLE.



// MARK: - 3. Weak Reference
//
// weak:
// - Does NOT keep the object alive
// - Must be optional
// - Automatically becomes nil when object is deallocated
// - Commonly used to break retain cycles


class EmployeeWeak {

    let name: String

    // Weak reference
    weak var department: DepartmentWeak?

    init(name: String) {
        self.name = name
        print("\(name) - EmployeeWeak Initialized")
    }

    deinit {
        print("\(name) - EmployeeWeak Deallocated")
    }
}


class DepartmentWeak {

    let name: String

    // Strong reference
    var employee: EmployeeWeak?

    init(name: String) {
        self.name = name
        print("\(name) - DepartmentWeak Initialized")
    }

    deinit {
        print("\(name) - DepartmentWeak Deallocated")
    }
}


// Create objects
var employeeWeak: EmployeeWeak? =
    EmployeeWeak(name: "John")

var departmentWeak: DepartmentWeak? =
    DepartmentWeak(name: "iOS")


// EmployeeWeak weakly references DepartmentWeak
employeeWeak?.department = departmentWeak


// DepartmentWeak strongly references EmployeeWeak
departmentWeak?.employee = employeeWeak


// Remove Employee external reference
employeeWeak = nil


// EmployeeWeak can be deallocated because
// DepartmentWeak does NOT need to be weak.
//
// DepartmentWeak.employee is a strong reference,
// so EmployeeWeak may remain alive here depending
// on the remaining ownership graph.
//
// Remove Department as well.
departmentWeak = nil


// The weak relationship prevents a cycle between
// the two objects.



// MARK: - 4. Closure Retain Cycle
//
// Closure retain cycle:
//
// Object → Closure → Object
//
// A closure captures `self` strongly by default.
//
// If the object stores that closure:
//
// self
//  ↓
// closure
//  ↓
// self
//
// This creates a retain cycle.


class DataModelStrong {

    let name: String

    var completion: (() -> Void)?

    init(name: String) {
        self.name = name
        print("\(name) - DataModelStrong Initialized")
    }

    func fetchData() {

        completion = {

            // Strong capture of self
            print("Data fetched")
            print(self.name)
        }
    }

    deinit {
        print("\(name) - DataModelStrong Deallocated")
    }
}


// Create object
var strongModel: DataModelStrong? =
    DataModelStrong(name: "Customer Data")


// Store closure
strongModel?.fetchData()


// Retain cycle:
//
// DataModelStrong
//       |
//       | strong
//       ↓
//   completion
//       |
//       | strong capture
//       ↓
// DataModelStrong


// Remove external reference
strongModel = nil


// The object may NOT be deallocated
// because the closure strongly retains self.
//
// This is a closure retain cycle.



// MARK: - 5. Weak Self
//
// `[weak self]`:
// - Does not strongly retain self
// - self becomes nil when object is deallocated
// - Common solution for closure retain cycles


class DataModelWeak {

    let name: String

    var completion: (() -> Void)?

    init(name: String) {
        self.name = name
        print("\(name) - DataModelWeak Initialized")
    }

    func fetchData() {

        completion = { [weak self] in

            // self is optional because weak references
            // automatically become nil.

            guard let self = self else {
                return
            }

            print("Data fetched")
            print(self.name)
        }
    }

    deinit {
        print("\(name) - DataModelWeak Deallocated")
    }
}


// Create object
var weakModel: DataModelWeak? =
    DataModelWeak(name: "Product Data")


// Create closure
weakModel?.fetchData()


// Object → Closure
//
// But:
//
// Closure -weak→ Object
//
// Therefore there is no strong retain cycle.


// Remove external reference
weakModel = nil


// DataModelWeak can now be deallocated.
//
// `deinit` will be called.



// MARK: - 6. Unowned Self
//
// unowned:
// - Does NOT keep the object alive
// - Does NOT become nil
// - Used when we KNOW the referenced object
//   will always exist when the closure executes
// - Accessing an unowned reference after
//   deallocation causes a runtime crash
//
// Use with caution.


class DataModelUnowned {

    let name: String

    var completion: (() -> Void)?

    init(name: String) {
        self.name = name
        print("\(name) - DataModelUnowned Initialized")
    }

    func fetchData() {

        completion = { [unowned self] in

            print("Data fetched")
            print(self.name)
        }
    }

    deinit {
        print("\(name) - DataModelUnowned Deallocated")
    }
}


// Create object
var unownedModel: DataModelUnowned? =
    DataModelUnowned(name: "Order Data")


// Create closure
unownedModel?.fetchData()


// IMPORTANT:
//
// `unowned self` assumes self will always exist
// when the closure executes.
//
// If self has already been deallocated and the
// closure tries to access self:
//
// Runtime crash can occur.


// In this example, do NOT execute the closure
// after setting unownedModel to nil.


// Remove external reference
unownedModel = nil



// MARK: - 7. deinit
//
// `deinit` is called before a class instance
// is removed from memory.
//
// You do NOT call deinit manually.
//
// ARC automatically triggers deinit when
// the object's strong reference count reaches zero.


class TestObject {

    let name: String

    init(name: String) {
        self.name = name

        print("\(name) - Initialized")
    }

    deinit {
        print("\(name) - Deinitialized")
    }
}


var testObject: TestObject? =
    TestObject(name: "Test")


// Object is alive
// Strong Reference Count = 1


testObject = nil


// Strong Reference Count = 0
//
// ARC deallocates the object.
//
// Output:
//
// Test - Initialized
// Test - Deinitialized
