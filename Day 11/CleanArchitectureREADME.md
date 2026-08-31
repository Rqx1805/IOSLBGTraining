# IOSLBGTraining

                    CLEAN ARCHITECTURE

┌─────────────────────────────────────────────┐
│              PRESENTATION                   │
│                                             │
│  SwiftUI View                              │
│       ↓                                     │
│  ViewModel / Observable                     │
└──────────────────────┬──────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────┐
│                  DOMAIN                     │
│                                             │
│  Entity                                    │
│  Use Case                                  │
│  Repository Protocol                       │
│                                             │
│  Business Rules                            │
└──────────────────────┬──────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────┐
│                   DATA                      │
│                                             │
│  Repository Implementation                 │
│  API / Network                             │
│  DTO / Data Source                         │
└─────────────────────────────────────────────┘

1. What Is Clean Architecture --

For IOS Example

Presentation
    ↓
Domain
    ↑
Data

a. Presentation: -

"Show a loading spinner."
"Display these users."
"Show an error alert."

b. Domain: -

"Fetch users."
"Only return active users."
"Sort users according to business rules."

c. Data: -

"Call REST API."
"Decode JSON."
"Read from database."
"Cache response."

2. Project Structure --

UserFeature/
│
├── Presentation/
│   ├── UserListView.swift
│   └── UserListViewModel.swift
│
├── Domain/
│   ├── Entities/
│   │   └── User.swift
│   │
│   ├── Repositories/
│   │   └── UserRepository.swift
│   │
│   └── UseCases/
│       └── FetchUsersUseCase.swift
│
└── Data/
    ├── DTO/
    │   └── UserDTO.swift
    │
    ├── Network/
    │   └── NetworkClient.swift
    │
    └── Repositories/
        └── UserRepositoryImpl.swift


3. DOMAIN Layer --

a. Ideally, it doesn't know about: -

❌ SwiftUI
❌ UIKit
❌ URLSession
❌ JSONDecoder
❌ API endpoints
❌ Database

b. It knows about: -

✅ Business entities
✅ Business rules
✅ Use cases
✅ Repository contracts


                   SWIFTUI
                      │
                      ▼
              ┌───────────────┐
              │ Presentation  │
              │               │
              │ View          │
              │ ViewModel     │
              └───────┬───────┘
                      │
                      ▼
              ┌───────────────┐
              │    Domain     │
              │               │
              │ Entity        │
              │ Use Case      │
              │ Repository    │
              │ Protocol      │
              └───────┬───────┘
                      ▲
                      │
              ┌───────┴───────┐
              │     Data      │
              │               │
              │ Repository    │
              │ DTO           │
              │ Network       │
              │ Database      │
              └───────────────┘
              
              


                 DOMAIN
                    │
          Business rules first
                    │
        ┌───────────┴───────────┐
        │                       │
 PRESENTATION                 DATA
 SwiftUI                    API/DB
 ViewModel                  Network
 
 
 4. Complete Architecture Flow --
 
 a. When the user opens the screen:-
 
 UserListView
     │
     │ .task
     ▼
UserListViewModel
     │
     │ loadUsers()
     ▼
FetchUsersUseCase
     │
     │ execute()
     ▼
UserRepository
     │
     │ fetchUsers()
     ▼
UserRepositoryImpl
     │
     ▼
NetworkClient
     │
     ▼
URLSession
     │
     ▼
REST API


b. Response:-

REST API
   ↓
Data
   ↓
UserDTO
   ↓
UserRepositoryImpl
   ↓
User
   ↓
FetchUsersUseCase
   ↓
ViewModel
   ↓
SwiftUI
