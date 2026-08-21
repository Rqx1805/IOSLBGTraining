import Foundation

// Define Protocol
protocol APIServiceProtocol {
    func fetchUser()
}

// Confirming Protocol

class APIService: APIServiceProtocol {
    func fetchUser() {
        print("Fetch Users")
    }
}

// Protocol Extension

protocol Vehicle {
    func start()
}

extension Vehicle {
    func start() {
        print("Default start")
    }
}

// Access Control

// 1. Open
open class Network {
    open func Data() {
        print("data")
    }
}

// In Another App/Module
class date: Network {
    override func Data() {
        print("data fetch")
    }
}
// 2. Public
public class NetworkManager {
    // 3. Private
    private var service: APIServiceProtocol
    
    // 4. File Private
    fileprivate var data: [Any] = []
    
    public init() {}
    
    public func display() {
        print("display data")
    }
}

// Another Module:
let userData = NetworkManager()
userData.display() // Allowed

class manager: NetworkManager { } // Not Allowed

// 5. Internal
class UserManager {
    func fetchUser() {
        print("user list")
    }
}

// Same Module
let user = UserManager()
user.fetchUser() // // Allowed

// Another Module:
let user = UserManager() // Not Allowed
