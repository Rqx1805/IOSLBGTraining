import Foundation

// MARK: - Base Class

class Vehicle {

    var brand: String

    init(brand: String) {
        self.brand = brand
        print("Vehicle created: \(brand)")
    }

    func start() {
        print("\(brand) is starting")
    }

    deinit {
        print("Vehicle deallocated: \(brand)")
    }
}


// MARK: - Child Class / Inheritance

class Car: Vehicle {

    var numberOfDoors: Int

    init(brand: String, numberOfDoors: Int) {
        self.numberOfDoors = numberOfDoors

        // Call parent class initializer
        super.init(brand: brand)

        print("Car created")
    }

    func drive() {
        print("\(brand) is driving")
    }

    deinit {
        print("Car deallocated")
    }
}


// MARK: - Service Class

class UserService {

    func fetchUsers() {
        print("Fetching users...")
    }

    deinit {
        print("UserService deallocated")
    }
}


// MARK: - Delegate Protocol

protocol UserViewModelDelegate: AnyObject {
    func dataUpdated()
}


// MARK: - ViewModel Class

class UserViewModel {

    // MARK: Properties

    private let service: UserService

    private(set) var users: [String] = []

    // weak prevents a strong reference cycle
    weak var delegate: UserViewModelDelegate?

    
    // MARK: Initializer

    init(service: UserService) {
        self.service = service

        print("UserViewModel created")
    }

    
    // MARK: Methods

    func loadUsers() {

        service.fetchUsers()

        users = [
            "Ashish",
            "Rahul",
            "Amit"
        ]

        delegate?.dataUpdated()
    }

    func addUser(name: String) {
        users.append(name)
    }

    func removeUser(at index: Int) {

        guard users.indices.contains(index) else {
            return
        }

        users.remove(at: index)
    }

    
    // MARK: Deinitialization

    deinit {
        print("UserViewModel deallocated")
    }
}


// MARK: - ViewController Class

class ViewController: UserViewModelDelegate {

    var viewModel: UserViewModel?

    init(viewModel: UserViewModel) {

        self.viewModel = viewModel

        print("ViewController created")
    }

    func dataUpdated() {

        print("ViewController received data update")

        print("Users: \(viewModel?.users ?? [])")
    }

    deinit {
        print("ViewController deallocated")
    }
}


// MARK: - Main Program

print("========== START ==========")


// --------------------------------------------------
// 1. Create Service
// --------------------------------------------------

var service: UserService? = UserService()


// --------------------------------------------------
// 2. Create ViewModel
// --------------------------------------------------

var viewModel1: UserViewModel? = UserViewModel(
    service: service!
)


// --------------------------------------------------
// 3. Shared Reference
// --------------------------------------------------

// viewModel1 and viewModel2 point to SAME object

var viewModel2 = viewModel1


// --------------------------------------------------
// 4. Object Identity
// --------------------------------------------------

print("Same object:", viewModel1 === viewModel2)


// --------------------------------------------------
// 5. Mutable State
// --------------------------------------------------

viewModel1?.loadUsers()

viewModel1?.addUser(name: "Vijay")

print("ViewModel 1 users:")
print(viewModel1?.users ?? [])

print("ViewModel 2 users:")
print(viewModel2?.users ?? [])


// Both contain the same data because they reference
// the same ViewModel object.


// --------------------------------------------------
// 6. Remove User
// --------------------------------------------------

viewModel2?.removeUser(at: 1)

print("After removing user:")

print(viewModel1?.users ?? [])


// --------------------------------------------------
// 7. ViewController
// --------------------------------------------------

var viewController: ViewController? =
    ViewController(viewModel: viewModel1!)


// Set delegate
viewModel1?.delegate = viewController


// Trigger update
viewModel1?.loadUsers()


// --------------------------------------------------
// 8. ARC Example
// --------------------------------------------------

// There are currently multiple strong references:
//
// viewModel1
// viewModel2
// viewController -> viewModel
//
// Setting viewModel1 to nil does NOT deallocate ViewModel.

viewModel1 = nil

print("viewModel1 removed")


// ViewModel is still alive because viewModel2
// and viewController still reference it.


// Remove second reference

viewModel2 = nil

print("viewModel2 removed")


// ViewModel is still alive because ViewController
// has a strong reference to it.


// Remove ViewController

viewController = nil

print("viewController removed")


// Now ViewModel can be deallocated because
// there are no strong references left.


// --------------------------------------------------
// 9. Remove Service
// --------------------------------------------------

service = nil


print("========== END ==========")
