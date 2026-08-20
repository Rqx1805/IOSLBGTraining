import Foundation

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
    // weak
    weak var employee: Employee?
    
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

class Department2 {
    var department: String
    
    // unowned
    unowned let employee: Employee
    
    // Department Initialized
    init(department: String, employee: Employee) {
        self.department = department
        self.employee = employee
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


// Real IOS Example - Delegate Pattern

protocol userViewControllerDelegate: AnyObject {
    func userData()
}

class userViewController {
    weak var delegate: userViewControllerDelegate?
    
    func userDataFetch() {
        print("User Data")
        delegate?.userData()
    }
}

