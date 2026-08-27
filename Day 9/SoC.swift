// Separation of Concerns

// Instead of putting everything in one UIViewController:

❌ UserViewController
   ├── UI
   ├── API call
   ├── JSON decoding
   ├── validation
   ├── business rules
   ├── database
   └── error handling

// We separate responsibilities: -

USER LIST FEATURE

┌───────────────────────────────┐
│              UI               │
│                               │
│ UserListViewController        │
│ UITableView                   │
│ Loading/Error presentation    │
└───────────────┬───────────────┘
│
▼
┌───────────────────────────────┐
│          BUSINESS             │
│                               │
│ UserListViewModel             │
│ State                         │
│ Business rules                │
│ Presentation decisions        │
└───────────────┬───────────────┘
│
▼
┌───────────────────────────────┐
│             DATA              │
│                               │
│ UserService                   │
│ API / URLSession              │
│ Repository                    │
│ JSON decoding                 │
└───────────────────────────────┘

// Recommended Module Structure: -

// For a small-to-medium UIKit application:

UserList/
│
├── Model/
│   └── User.swift
│
├── View/
│   ├── UserListViewController.swift
│   └── UserTableViewCell.swift
│
├── ViewModel/
│   └── UserListViewModel.swift
│
├── Service/
│   ├── UserService.swift
│   └── UserServiceProtocol.swift
│
├── Network/
│   ├── NetworkClient.swift
│   └── NetworkClientProtocol.swift
│
└── Tests/
    ├── UserListViewModelTests.swift
    └── MockUserService.swift

// 3. Architecture Boundaries: -

View
 ↓
ViewModel
 ↓
Service abstraction
 ↓
Data/Network

// Below Avoid: -

View
 ↓
URLSession

ViewModel
 ↓
UIViewController

Service
 ↓
UIViewController

// Because each layer should have a boundary: -

ViewController
    │
    │ asks ViewModel
    ▼
ViewModel
    │
    │ asks UserServiceProtocol
    ▼
Service
    │
    │ asks NetworkClient
    ▼
Network
