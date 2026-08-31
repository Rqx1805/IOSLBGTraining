import Foundation

// ============================================================
// AccessControl.swift
// ============================================================
//
// Swift Access Control:
//
// open        -> Accessible everywhere + subclassable/overridable
//                outside the defining module.
//
// public      -> Accessible everywhere, but a public class/
//                member is not generally subclassable/overridable
//                outside the defining module.
//
// package     -> Accessible anywhere within the same Swift package.
//
// internal    -> Accessible anywhere within the same module.
//                Default access level.
//
// fileprivate -> Accessible only within the same source file.
//
// private     -> Accessible only within the enclosing declaration
//                and its extensions in the same file.
//
// ============================================================



// MARK: - 1. OPEN
//
// `open` is the most permissive access level.
//
// An open class can:
// - Be accessed from another module.
// - Be subclassed outside its defining module.
// - Have open methods/properties overridden outside its module.
//
// IMPORTANT:
// `open` is mainly useful for framework/library code.

 class BaseViewController {

    open var screenTitle: String = "Base Screen"

    public init() {
    }

    open func displayScreen() {
        print("Displaying \(screenTitle)")
    }
}


// Example subclass.
//
// This is allowed when BaseViewController comes from
// another module and is declared `open`.

class LoginViewController: BaseViewController {

    override func displayScreen() {

        print("Displaying Login Screen")
    }
}

let loginVC = LoginViewController()

loginVC.displayScreen()



// MARK: - 2. PUBLIC
//
// `public` means the declaration can be accessed
// from outside the defining module.
//
// However, a public class cannot generally be subclassed
// outside its defining module.
//
// `public` is commonly used for APIs exposed by frameworks.

 class APIService {

    public init() {
    }

    public func fetchData() {

        print("Fetching API data")
    }
}


// Public class and public method can be accessed
// from another module.

let apiService = APIService()

apiService.fetchData()



// MARK: - 3. PACKAGE
//
// `package` is available within the SAME SWIFT PACKAGE.
//
// It is useful when multiple modules/targets inside
// one Swift Package need to share implementation details.
//
// It is more restrictive than public.


package class PackageService {

    package init() {
    }

    package func execute() {

        print("Package service executed")
    }
}


// This is accessible from another target/module
// belonging to the same Swift Package.
//
// Example:
//
// let service = PackageService()
// service.execute()
//
// Outside the Swift Package, it is NOT accessible.



// MARK: - 4. INTERNAL
//
// `internal` is the DEFAULT access level in Swift.
//
// It is accessible anywhere within the SAME MODULE.
//
// You do not have to explicitly write `internal`.
//
// These two declarations are equivalent:
//
// class UserManager { }
//
// internal class UserManager { }


class UserManager {

    var username: String

    init(username: String) {
        self.username = username
    }

    func printUsername() {

        print("Username: \(username)")
    }
}


// `UserManager` is internal by default.

let userManager = UserManager(username: "Ashish")

userManager.printUsername()


// You can also explicitly use `internal`.

internal class ProductManager {

    internal func fetchProducts() {

        print("Fetching products")
    }
}


let productManager = ProductManager()

productManager.fetchProducts()



// MARK: - 5. FILEPRIVATE
//
// `fileprivate` means the declaration is accessible
// anywhere inside THIS SOURCE FILE.
//
// It is more restrictive than internal.
//
// It can be useful when two types in the same file
// need to share implementation details.


class User {

    fileprivate var password: String

    init(password: String) {
        self.password = password
    }
}


class UserManagerFilePrivate {

    func changePassword(for user: User) {

        // Allowed because UserManagerFilePrivate
        // is in the SAME FILE.

        user.password = "NewPassword"

        print("Password changed")
    }
}


let user = User(password: "OldPassword")

let manager = UserManagerFilePrivate()

manager.changePassword(for: user)



// MARK: - 6. PRIVATE
//
// `private` is the most restrictive access level.
//
// It is accessible only inside the enclosing
// declaration and its extensions in the same file.
//
// Use private to hide implementation details.


class BankAccount {

    private var balance: Double = 0

    func deposit(amount: Double) {

        balance += amount

        print("Balance: \(balance)")
    }

    func withdraw(amount: Double) {

        guard amount <= balance else {

            print("Insufficient balance")
            return
        }

        balance -= amount

        print("Balance: \(balance)")
    }

    func getBalance() -> Double {

        return balance
    }
}


let account = BankAccount()

account.deposit(amount: 1000)

account.withdraw(amount: 300)

print("Current Balance: \(account.getBalance())")


// This would NOT compile:
//
// account.balance = 1000
//
// ERROR:
// 'balance' is inaccessible due to 'private' protection level.



// MARK: - PRIVATE vs FILEPRIVATE
//
// PRIVATE
//
// Accessible inside the declaration
// and its same-file extensions.
//
// FILEPRIVATE
//
// Accessible anywhere in the same source file.
//
// Example:


class SecureUser {

    private var token: String = "ABC123"

    fileprivate var userID: Int = 1001

    func printToken() {

        // Allowed
        print(token)
    }
}


extension SecureUser {

    func printTokenFromExtension() {

        // `private` is accessible from an extension
        // of the same declaration in the same file.

        print(token)
    }
}


class AnotherClassInSameFile {

    func printUserID(user: SecureUser) {

        // Allowed because userID is fileprivate
        // and this class is in the same file.

        print(user.userID)
    }

    // This would NOT compile:
    //
    // print(user.token)
    //
    // because token is private to SecureUser.
}



// MARK: - Practical iOS Example
//
// A common iOS architecture can use access control
// like this:
//
// ViewController
//      |
//      ↓
// ViewModel
//      |
//      ↓
// APIService
//
// Keep implementation details private while exposing
// only what other layers need.

 class UserViewModel {

    // Private implementation detail
    private let service: APIService

    // Public initializer
    public init(service: APIService) {

        self.service = service
    }

    // Public API
    public func loadUsers() {

        service.fetchData()
    }

    // Private helper
    private func processUsers() {

        print("Processing users")
    }
}


let service = APIService()

let viewModel = UserViewModel(service: service)

viewModel.loadUsers()



// ============================================================
// QUICK SUMMARY
// ============================================================
//
// OPEN
// ↓
// Accessible outside module
// + subclassable outside module
//
// PUBLIC
// ↓
// Accessible outside module
// - generally not subclassable outside module
//
// PACKAGE
// ↓
// Accessible within same Swift Package
//
// INTERNAL
// ↓
// Accessible within same module
// Default access level
//
// FILEPRIVATE
// ↓
// Accessible within same Swift source file
//
// PRIVATE
// ↓
// Accessible within enclosing declaration/scope
//
// ============================================================
