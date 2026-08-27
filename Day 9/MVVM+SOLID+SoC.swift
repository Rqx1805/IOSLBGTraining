// MVVM + SOLID + Separation of Concerns

// All of these concepts work together: -

MVVM
 │
┌─────────┼─────────┐
▼         ▼         ▼
View    ViewModel   Model
│         │
│         │
│         ▼
│      Protocol
│         │
│         ▼
│      Service
│         │
│         ▼
│      Network
│
▼
UIKit

// Architecture rules: -

1. ViewController → UI responsibility

2. ViewModel → state + business/presentation logic

3. Model → data/domain representation

4. Service → API/data operations

5. Network layer → HTTP communication

6. Repository → data source abstraction

7. Use Case → complex business workflow

8. Protocol → boundary/abstraction

9. Dependency Injection → provide dependencies from outside

10. UI should NOT directly access networking/database

// Simplest Model: -

WHAT TO DISPLAY?
       ↑
       │
 ViewModel
       ↑
       │
WHAT TO DO?
       ↑
       │
  Use Case
       ↑
       │
WHERE DATA?
       ↑
       │
Repository
       ↑
       │
HOW TO GET?
       ↑
       │
Network / Database
