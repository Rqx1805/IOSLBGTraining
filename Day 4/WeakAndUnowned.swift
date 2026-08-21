import Foundation


// MARK: - WEAK
//
// weak:
// - Does NOT increase the strong reference count.
// - Must be optional.
// - Automatically becomes nil when the object is deallocated.
// - Commonly used for delegates.
// - Commonly used to break retain cycles.


// MARK: Weak Usage Case: Delegate

protocol EmployeeDelegate: AnyObject {
    func employeeDidUpdate()
}


class Employee {

    let name: String

    // weak is correct for delegate references.
    // Employee does NOT own its delegate.
    weak var delegate: EmployeeDelegate?

    init(name: String) {
        self.name = name
        print("\(name) Employee Initialized")
    }

    func updateEmployee() {
        print("Employee updated")

        delegate?.employeeDidUpdate()
    }

    deinit {
        print("\(name) Employee Deallocated")
    }
}


class EmployeeViewController: EmployeeDelegate {

    let titleName: String

    init(titleName: String) {
        self.titleName = titleName
        print("\(titleName) ViewController Initialized")
    }

    func employeeDidUpdate() {
        print("Employee update received by ViewController")
    }

    deinit {
        print("\(titleName) ViewController Deallocated")
    }
}


// Create Employee
var employee: Employee? = Employee(name: "Ashish")


// Create ViewController
var viewController: EmployeeViewController? =
    EmployeeViewController(titleName: "Employee Screen")


// Employee has a WEAK reference to ViewController
employee?.delegate = viewController


// Call update
employee?.updateEmployee()


// Remove ViewController
viewController = nil

// Because delegate is weak:
//
// employee?.delegate automatically becomes nil.
//
// Employee does NOT keep ViewController alive.


// Remove Employee
employee = nil



// MARK: - WEAK Usage Case: Retain Cycle Prevention
//
// Without weak:
//
// Employee → Department
//     ↑          |
//     |          |
//     └──────────┘
//
// Both objects strongly reference each other.
//
// Using weak on one side breaks the cycle.


class Department {

    let name: String

    // Weak reference breaks the retain cycle.
    weak var employee: Employee?

    init(name: String) {
        self.name = name
        print("\(name) Department Initialized")
    }

    deinit {
        print("\(name) Department Deallocated")
    }
}


// Create new Employee
var employee2: Employee? = Employee(name: "Rahul")


// Create Department
var department: Department? =
    Department(name: "iOS Development")


// Employee strongly references Department
// Note: Employee.delegate is unrelated here.
// This example demonstrates weak ownership from Department.
department?.employee = employee2


// Remove Employee
employee2 = nil

// Department.employee automatically becomes nil.
//
// Employee can be deallocated because Department
// does not strongly retain Employee.


// Remove Department
department = nil



// MARK: - UNOWNED
//
// unowned:
// - Does NOT increase strong reference count.
// - Does NOT become nil.
// - Usually used when one object's lifetime is
//   guaranteed to be longer than the other's.
// - Accessing an unowned reference after the object
//   has been deallocated causes a runtime crash.
//
// IMPORTANT:
// Use unowned ONLY when the lifetime relationship
// is guaranteed.


// MARK: Unowned Usage Case: Credit Card and Customer
//
// A CreditCard cannot exist without its Customer.
// The Customer owns the CreditCard.
//
// CreditCard has an unowned reference to Customer.
//
// Customer → strong → CreditCard
// CreditCard → unowned → Customer
//
// This is a valid unowned relationship because
// the Customer is guaranteed to exist while the
// CreditCard is being used.


class Customer {

    let name: String

    var creditCard: CreditCard?

    init(name: String) {
        self.name = name
        print("\(name) Customer Initialized")
    }

    deinit {
        print("\(name) Customer Deallocated")
    }
}


class CreditCard {

    let number: Int

    // Customer is guaranteed to exist while
    // the CreditCard is being used.
    unowned let customer: Customer

    init(number: Int, customer: Customer) {
        self.number = number
        self.customer = customer

        print("CreditCard \(number) Initialized")
    }

    func showCustomer() {
        print("Customer: \(customer.name)")
    }

    deinit {
        print("CreditCard \(number) Deallocated")
    }
}


// Create Customer
var customer: Customer? =
    Customer(name: "Ashish")


if let customer = customer {

    // Customer strongly owns CreditCard
    customer.creditCard =
        CreditCard(
            number: 1234,
            customer: customer
        )

    // CreditCard has an unowned reference
    // back to Customer.

    customer.creditCard?.showCustomer()
}


// Remove Customer
customer = nil

// CreditCard is also released because Customer
// strongly owns the CreditCard.
//
// The CreditCard's unowned reference does NOT
// keep Customer alive.



// MARK: - UNOWNED Usage Case: Closure
//
// Use [unowned self] when the closure's lifetime
// is guaranteed to be shorter than self's lifetime.
//
// Example:
// A closure stored temporarily and executed while
// the owner is guaranteed to exist.


class DataLoader {

    let name: String

    init(name: String) {
        self.name = name
    }

    func loadData(completion: @escaping () -> Void) {

        completion()
    }

    func start() {

        loadData { [unowned self] in

            // Safe ONLY because self is guaranteed
            // to exist when this closure executes.
            print("Data loaded for \(self.name)")
        }
    }

    deinit {
        print("\(name) DataLoader Deallocated")
    }
}


// Create DataLoader
let loader = DataLoader(name: "User")


// Closure executes immediately while loader exists.
loader.start()
