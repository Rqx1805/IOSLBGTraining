UserFeature
│
├── Model
│   └── User.swift
│
├── Network
│   ├── UserServiceProtocol.swift
│   ├── UserService.swift
│   └── NetworkError.swift
│
├── ViewModel
│   └── UserListViewModel.swift
│
├── View
│   ├── UserListViewController.swift
│   └── UserTableViewCell.swift
│
└── Tests
    ├── UserListViewModelTests.swift
    └── MockUserService.swift

User
 ↓
ViewController
 ↓
ViewModel
 ↓
UserServiceProtocol
 ↓
UserService
 ↓
URLSession
 ↓
API
 ↓
JSON
 ↓
[User]
 ↓
ViewModel.users
 ↓
ViewController
 ↓
UITableView


MVVM + SOLID

   USER
    │
    ▼
┌──────────────┐
│     VIEW     │
│ UIKit / VC   │
└──────┬───────┘
    │
    ▼
┌──────────────┐
│  VIEWMODEL   │
│ State        │
│ Logic        │
└──────┬───────┘
    │
    ▼
┌──────────────┐
│  PROTOCOL    │
│ Abstraction  │
└──────┬───────┘
    │
┌──────┴───────┐
▼              ▼
┌────────────┐  ┌────────────┐
│ RealService│  │ MockService│
│ Production │  │ Unit Test  │
└─────┬──────┘  └────────────┘
│
▼
URLSession
│
▼
API
│
▼
JSON → Model
