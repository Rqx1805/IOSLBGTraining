import Foundation


// MARK: - PROTOCOL
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


// MARK: - 1. Basic Protocol

protocol VehicleProtocol {

    var name: String { get }

    func start()
}


// MARK: - 2. Struct Conforming to Protocol

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
// BMW started



// MARK: - 3. Another Type Conforming to Same Protocol

struct Bike: VehicleProtocol {

    let name: String

    func start() {
        print("\(name) bike started")
    }
}


let bike = Bike(name: "Bullet")

bike.start()

// Output:
// Honda bike started



// MARK: - 4. Protocol as a Type
//
// We can store different conforming types
// using the protocol type.
//
// This helps us write loosely coupled code.


let vehicle1: any VehicleProtocol = Car(name: "KIA")

let vehicle2: any VehicleProtocol = Bike(name: "Bullet")

vehicle1.start()
vehicle2.start()


// Both Car and Bike can be used through
// the same protocol interface.


// MARK: - 5. Protocol Extension
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


// Car must implement start()
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
//
// Ferrari started
// Ferrari stopped



// MARK: - 6. Override Default Implementation
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
//
// Tesla started silently
// Tesla stopped automatically



// MARK: - 7. Protocol Helps Avoid Tight Coupling
//
// BAD DESIGN:
//
// ViewModel directly depends on a concrete
// APIService class.
//
// UserViewModel → APIService
//
// This makes testing and replacing the service
// more difficult.
//
// Instead:
//
// UserViewModel → UserServiceProtocol
//                     ↑
//               APIService
//
// Now UserViewModel depends on an abstraction.


protocol UserServiceProtocol {

    func fetchUsers()
}


class APIService: UserServiceProtocol {

    func fetchUsers() {

        print("Fetching users from API...")
    }
}


class UserViewModel {

    // Dependency is the PROTOCOL,
    // not the concrete APIService.
    private let service: any UserServiceProtocol

    init(service: any UserServiceProtocol) {

        self.service = service
    }

    func loadUsers() {

        service.fetchUsers()
    }
}


// Create concrete service

let apiService = APIService()


// Inject service into ViewModel

let userViewModel = UserViewModel(
    service: apiService
)


// Load users

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



// MARK: - 9. Multiple Implementations
//
// This is where protocols become very useful.
//
// Production implementation:

class ProductionUserService: UserServiceProtocol {

    func fetchUsers() {

        print("Fetching users from Production API")
    }
}


// Mock implementation for testing:

class MockUserService: UserServiceProtocol {

    func fetchUsers() {

        print("Returning mock users")
    }
}


// ViewModel does NOT need to know which
// implementation it receives.

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
//
// Fetching users from Production API
// Returning mock users



// MARK: - 10. Practical iOS MVVM Example
//
// Common architecture:
//
// ViewController
//       |
//       ↓
// UserViewModel
//       |
//       ↓
// UserServiceProtocol
//       ↑
//       |
// APIService / MockUserService
//
// The ViewModel depends on the protocol,
// not on a specific service.


protocol UserDataServiceProtocol {

    func fetchUsers() -> [String]
}


class RealUserDataService: UserDataServiceProtocol {

    func fetchUsers() -> [String] {

        return [
            "Ashish",
            "Rahul",
            "Amit"
        ]
    }
}


class MockUserDataService: UserDataServiceProtocol {

    func fetchUsers() -> [String] {

        return [
            "Test User 1",
            "Test User 2"
        ]
    }
}


class UserListViewModel {

    private let service: any UserDataServiceProtocol

    private(set) var users: [String] = []

    init(service: any UserDataServiceProtocol) {

        self.service = service
    }

    func loadUsers() {

        users = service.fetchUsers()
    }
}


// Production

let realService: any UserDataServiceProtocol =
    RealUserDataService()

let realViewModel = UserListViewModel(
    service: realService
)

realViewModel.loadUsers()

print(realViewModel.users)


// Unit-test/mock

let mockDataService: any UserDataServiceProtocol =
    MockUserDataService()

let mockViewModel = UserListViewModel(
    service: mockDataService
)

mockViewModel.loadUsers()

print(mockViewModel.users)



// MARK: - IMPORTANT SUMMARY
//
// PROTOCOL
//
// Defines a contract.
//
// Example:
//
// protocol UserServiceProtocol {
//     func fetchUsers()
// }
//
//
// CONFORMANCE
//
// class APIService: UserServiceProtocol
//
//
// PROTOCOL EXTENSION
//
// Provides default behavior.
//
// extension VehicleProtocol {
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
//     ↓
// Protocol
//     ↑
// Service
//
// Instead of:
//
// ViewModel
//     ↓
// Concrete Service
//
//
// TESTING
//
// Production:
// UserServiceProtocol → APIService
//
// Testing:
// UserServiceProtocol → MockUserService
