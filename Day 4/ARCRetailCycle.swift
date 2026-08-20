import Foundation

class Customer {
    var name: String
    
    // Customer Initialized
    init(name: String) {
        self.name = name
        print(self.name, "Customer Initialized")
    }
    
    // Customer Deallocated
    deinit {
        print("Customer Deallocated")
    }
}

var firstCustomer: Customer? Customer(name: "David")
var secondCustomer = firstCustomer // Reference Count 2

firstCustomer = nil // Reference Count 0
secondCustomer = nil // Reference Count 0


// Retail Cycle

class Employee {
    var name: String
    var department: Department?
    
    // Employee Initialized
    init(name: String) {
        self.name = name
        print(self.name, "Employee Initialized")
    }
    
    // Employee Deallocated
    deinit {
        print("Employee Deallocated")
    }
}

class Department {
    var department: String
    var employee: Employee?
    
    // Department Initialized
    init(department: String) {
        self.department = department
        print(self.department, "Department Initialized")
    }
    
    // Department Deallocated
    deinit {
        print("Department Deallocated")
    }
}

var realEmployee: Employee? = Employee(name: "Jack")
var actualDepartment: Department? = Department(department: "Development")

realEmployee?.department = actualDepartment
actualDepartment?.employee = realEmployee

realEmployee = nil
actualDepartment = nil

// Retain Cycle in Closures

class dataModel {
    var completion: (() -> Void)?
    
    func fetchData() {
        completion = {
            print(self)
        }
    }
}

// Above Model Create Ratain Becuase Closures Capture self Storngly.
// Avoid Retain Cycle Below Solution We Are Used [weak self].

class dataModel {
    var completion: (() -> Void)?
    
    func fetchData() {
        completion = { [weak self] in
            guard let self = self else {
                return
            }
            print("Data Fetched")
            print(self)
        }
    }
    // Use Unowned Only When We Are Sure The Closure Will Never Excute After self is deallocated.
    func fetchDataWithUnowned() {
        completion = { [unowned self] in
            print(self)
        }
    }

}

