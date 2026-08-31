import Foundation

// MARK: - 1. BASIC PROTOCOL
//
// A protocol defines a CONTRACT.
//
// "Any type conforming to me must provide
// these properties or functions."
//
// Protocols help us create loosely coupled code.
//
// A protocol does NOT create an object by itself.
// A class, struct, or enum can conform to a protocol.

protocol VehicleProtocol {
    var name: String { get }
    func start()
}

// MARK: - 2. STRUCT CONFORMING TO PROTOCOL

struct Car: VehicleProtocol {
    let name: String

    func start() {
        print("\(name) car started")
    }
}

// Create Car
let car = Car(name: "KIA")
car.start()

// Output:
// KIA car started


// MARK: - 3. ANOTHER TYPE CONFORMING TO SAME PROTOCOL

struct Bike: VehicleProtocol {
    let name: String

    func start() {
        print("\(name) bike started")
    }
}

let bike = Bike(name: "Bullet")
bike.start()

// Output:
// Bullet bike started


// MARK: - 4. PROTOCOL AS A TYPE
//
// We can store different conforming types
// using the protocol type.
//
// "any VehicleProtocol" means the value can contain
// any concrete type that conforms to VehicleProtocol.

let vehicle1: any VehicleProtocol = Car(name: "KIA")
let vehicle2: any VehicleProtocol = Bike(name: "Bullet")

vehicle1.start()
vehicle2.start()

// Output:
// KIA car started
// Bullet bike started


// MARK: - 5. PROTOCOL EXTENSION
//
// Protocol extensions allow us to provide
// DEFAULT IMPLEMENTATIONS.
//
// A conforming type does not have to implement
// the method if it wants to use the default behavior.

protocol VehicleProtocolWithDefault {
    var name: String { get }
    func start()
    func stop()
}

extension VehicleProtocolWithDefault {
    func stop() {
        print("\(name) stopped")
    }
}

// SportsCar must implement start()
// but can use the default stop() implementation.

struct SportsCar: VehicleProtocolWithDefault {
    let name: String

    func start() {
        print("\(name) started")
    }
}

let sportsCar = SportsCar(name: "Mustang")

sportsCar.start()
sportsCar.stop()

// Output:
// Mustang started
// Mustang stopped


// MARK: - 6. OVERRIDE DEFAULT IMPLEMENTATION
//
// A conforming type can provide its own
// implementation instead of using the default.

struct ElectricCar: VehicleProtocolWithDefault {
    let name: String

    func start() {
        print("\(name) started silently")
    }

    func stop() {
        print("\(name) stopped automatically")
    }
}

let electricCar = ElectricCar(name: "Tesla")

electricCar.start()
electricCar.stop()

// Output:
// Tesla started silently
// Tesla stopped automatically


// MARK: - 7. PROTOCOL HELPS AVOID TIGHT COUPLING
//
// BAD DESIGN:
//
// UserViewModel → APIService
//
// The ViewModel directly depends on a concrete
// APIService class.
//
// This makes testing and replacing the service
// more difficult.
//
// GOOD DESIGN:
//
// UserViewModel → UserServiceProtocol
//                      ↑
//                APIService
//
// The ViewModel depends on an abstraction
// instead of a concrete implementation.

protocol UserServiceProtocol {
    func fetchUsers()
}

final class APIService: UserServiceProtocol {

    func fetchUsers() {
        print("Fetching users from API...")
    }
}

final class UserViewModel {

    private let service: any UserServiceProtocol

    init(service: any UserServiceProtocol) {
        self.service = service
    }

    func loadUsers() {
        service.fetchUsers()
    }
}

// Dependency Injection
let apiService: any UserServiceProtocol = APIService()

let userViewModel = UserViewModel(
    service: apiService
)

userViewModel.loadUsers()

// Output:
// Fetching users from API...


// MARK: - 8. `any UserServiceProtocol`
//
// Swift allows a protocol to be used as an existential type.
//
// `any` explicitly means:
//
// "This variable can contain any value whose type
// conforms to UserServiceProtocol."

let service: any UserServiceProtocol = APIService()

service.fetchUsers()

// Output:
// Fetching users from API...


// MARK: - 9. MULTIPLE IMPLEMENTATIONS
//
// This is where protocols become very useful.
//
// Production implementation:
final class ProductionUserService: UserServiceProtocol {

    func fetchUsers() {
        print("Fetching users from Production API")
    }
}

// Mock implementation for testing:
final class MockUserService: UserServiceProtocol {

    func fetchUsers() {
        print("Returning mock users")
    }
}

// ViewModel does NOT need to know
// which implementation it receives.

let productionService: any UserServiceProtocol =
    ProductionUserService()

let mockService: any UserServiceProtocol =
    MockUserService()

let productionViewModel = UserViewModel(
    service: productionService
)

let testViewModel = UserViewModel(
    service: mockService
)

productionViewModel.loadUsers()
testViewModel.loadUsers()

// Output:
// Fetching users from Production API
// Returning mock users


// MARK: - 10. PRACTICAL iOS MVVM EXAMPLE
//
// Architecture:
//
// ViewController
//       |
//       ↓
// UserListViewModel
//       |
//       ↓
// UserDataServiceProtocol
//       ↑
//       |
// RealUserDataService / MockUserDataService
//
// The ViewModel depends on the protocol,
// not on a specific service.

protocol UserDataServiceProtocol {
    func fetchUsers() -> [String]
}


// MARK: - Configuration / Constants
//
// Keeping demo data in one place avoids
// scattering hardcoded values throughout the code.

enum UserDataConfiguration {

    static let productionUsers = [
        "Ashish",
        "Rahul",
        "Amit"
    ]

    static let mockUsers = [
        "Test User 1",
        "Test User 2"
    ]
}


// MARK: - REAL DATA SERVICE

final class RealUserDataService: UserDataServiceProtocol {

    func fetchUsers() -> [String] {
        UserDataConfiguration.productionUsers
    }
}


// MARK: - MOCK DATA SERVICE
//
// Used for Unit Testing.

final class MockUserDataService: UserDataServiceProtocol {

    func fetchUsers() -> [String] {
        UserDataConfiguration.mockUsers
    }
}


// MARK: - VIEW MODEL

final class UserListViewModel {

    private let service: any UserDataServiceProtocol

    private(set) var users: [String] = []

    init(service: any UserDataServiceProtocol) {
        self.service = service
    }

    func loadUsers() {
        users = service.fetchUsers()
    }
}


// MARK: - PRODUCTION

let realService: any UserDataServiceProtocol =
    RealUserDataService()

let realViewModel = UserListViewModel(
    service: realService
)

realViewModel.loadUsers()

print(realViewModel.users)

// Output:
// ["Ashish", "Rahul", "Amit"]


// MARK: - UNIT TEST / MOCK

let mockDataService: any UserDataServiceProtocol =
    MockUserDataService()

let mockViewModel = UserListViewModel(
    service: mockDataService
)

mockViewModel.loadUsers()

print(mockViewModel.users)

// Output:
// ["Test User 1", "Test User 2"]


// MARK: - IMPORTANT SUMMARY
//
// PROTOCOL
//
// Defines a contract.
//
// protocol UserServiceProtocol {
//     func fetchUsers()
// }
//
//
// CONFORMANCE
//
// A type agrees to follow the protocol.
//
// final class APIService: UserServiceProtocol {
//     ...
// }
//
//
// PROTOCOL EXTENSION
//
// Provides default behavior.
//
// extension VehicleProtocolWithDefault {
//     func stop() {
//         print("Stopped")
//     }
// }
//
//
// ANY
//
// Explicit existential protocol type.
//
// let service: any UserServiceProtocol
//
//
// LOOSE COUPLING
//
// ViewModel
//      ↓
// Protocol
//      ↑
// Service
//
// Instead of:
//
// ViewModel
//      ↓
// Concrete Service
//
//
// DEPENDENCY INJECTION
//
// Dependencies are passed from outside.
//
// UserListViewModel(
//     service: realService
// )
//
//
// TESTING
//
// Production:
//
// UserDataServiceProtocol
//          ↑
// RealUserDataService
//
//
// Testing:
//
// UserDataServiceProtocol
//          ↑
// MockUserDataService
//
//
// FINAL
//
// `final` prevents inheritance.
//
// final class APIService { }
//
// Use `final` when a class is not designed
// to be subclassed.
//
//
// ACCESS CONTROL
//
// Avoid adding `public` or `internal` unnecessarily.
//
// Swift's default access level is `internal`.
//
// Use `private` only when encapsulation is required,
// such as:
//
// private let service
// private(set) var users
//
//
// IMPLICIT RETURN
//
// For a single-expression function:
//
// func fetchUsers() -> [String] {
//     UserDataConfiguration.productionUsers
// }
//
// No explicit `return` is required.
//
//
// BENEFITS OF THIS DESIGN
//
// 1. Loose coupling
// 2. Dependency Injection
// 3. Easy Unit Testing
// 4. Easy mocking
// 5. Easy replacement of services
// 6. Better maintainability
// 7. Follows SOLID principles
// 8. Suitable for MVVM
// 9. Supports Clean Architecture
// 10. Easier code review and maintenance
