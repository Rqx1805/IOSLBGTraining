// 1. MVVM = Model + View + ViewModel
┌─────────────────┐
│      MODEL      │
│                 │
│ User            │
│ API data        │
└────────┬────────┘
         │
         ↓
┌─────────────────┐
│   VIEWMODEL     │
│                 │
│ Business logic  │
│ State           │
│ API call        │
│ Error handling  │
└────────┬────────┘
         │
         ↓
┌─────────────────┐
│      VIEW      │
│                 │
│ UIViewController│
│ UITableView     │
│ Loading/Error UI │
└─────────────────┘

// 2. Small MVVM Flow

// The flow is:

User opens screen
       ↓
ViewController
       ↓
ViewModel.loadUsers()
       ↓
UserService
       ↓
API
       ↓
[User]
       ↓
ViewModel
       ↓
ViewController
       ↓
UITableView

// For a clean architecture:

View
  ↓
ViewModel
  ↓
Protocol
  ↓
Service
  ↓
URLSession
  ↓
API

// 3. Model Responsibility

//It should not know about:
//
//UIViewController
//UITableView
//UI colors
//UIAlertController
//navigation

struct User: Decodable {

    let id: Int
    let name: String
    let email: String
}

// Represent user data.

// 4. Service Responsibility

// Create a protocol:

protocol UserServiceProtocol {

    func fetchUsers() async throws -> [User]
}

// Then concrete implementation:
final class UserService: UserServiceProtocol {
    
    private let session: URLSession
}

// 5. ViewModel Responsibility

//The ViewModel is the most important part of MVVM.
//
//It handles:
//
//Business logic
//Screen state
//Calling service
//Transforming data
//Error state
//Loading state


@MainActor
final class UserListViewModel {
    
    private let service: any UserServiceProtocol
    
    private(set) var users: [User] = []
    
    private(set) var isLoading = false
    
    private(set) var errorMessage: String?
    
    init(service: any UserServiceProtocol) {
        self.service = service
    }
    
    func fetchUser() {
        // code
    }
}

// 6. View Responsibility

//In UIKit, the View is usually represented by:
//
//The ViewController should:
//
//Create UI
//Display ViewModel state
//Handle user interaction
//Reload table
//Show alerts
//Navigate
//
//It should not contain business logic or networking code.


//7. UITableView Responsibility

//The ViewController displays the data:

// 8. Complete MVVM Model

User
│
│ Model
│
↓
UserServiceProtocol
│
↓
UserService
│
│ Networking
│
↓
API
│
↓
[User]
│
↓
UserListViewModel
│
│ State + Business Logic
│
↓
UserListViewController
│
│ UI
│
↓
UITableView
