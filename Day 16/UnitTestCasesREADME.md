# IOSLBGTraining


Production Code
      ↓
Testable through Dependency Injection
      ↓
XCTest
      ↓
Validate expected behavior + edge cases

✓ Utility functions
✓ Models/business rules
✓ ViewModels
✓ Use Cases
✓ Repository logic
✓ Validation
✓ Error handling


App
 ↓
View
 ↓
ViewModel
 ↓
UseCase
 ↓
Repository
 ↓
API


                PRODUCT FEATURE
                       │
        ┌──────────────┴──────────────┐
        │                             │
   PRODUCTION                       TEST
        │                             │
        ▼                             ▼
ProductListView                ViewModelTests
        │                             │
        ▼                             ▼
ProductViewModel              MockUseCase
        │
        ▼
GetProductsUseCase            UseCaseTests
        │                             │
        ▼                             ▼
ProductRepository             MockRepository
        │
        ▼
NetworkClient                  RepositoryTests
        │                             │
        ▼                             ▼
      API                       MockNetwork
      
    
    
    
                        XCTest
                      │
          ┌───────────┼───────────┐
          ↓           ↓           ↓
      ViewModel     UseCase    Repository
          │           │           │
      Mock UseCase  Mock Repo   Mock Network
      
      
Unit Test
    ↓
Small unit
    ↓
Isolate dependencies
    ↓
Arrange
    ↓
Act
    ↓
Assert
    ↓
Test success + failure + edge cases
