import Foundation

// Protocol-Based Dependency

protocol UserServiceProtocol {
    func fetchUser() async throws -> [User]
}
// This is the dependency that the ViewModel will consume.

// Real Service
final class UserService: UserServiceProtocol {
    
    private let networkClient: any NetworkServiceProtocol
    
    init(networkClient: any NetworkServiceProtocol) {
        self.networkClient = networkClient
    }
    
    func fetchUsers() async throws -> [User] {
        
        guard let url = URL(
            string:
                "https://jsonplaceholder.typicode.com/users"
        ) else {
            
            throw NetworkError.invalidURL
        }
        
        let (data, response) =
        try await networkClient.request(
            from: url
        )
        
        guard let httpResponse =
                response as? HTTPURLResponse else {
            
            throw NetworkError.invalidResponse
        }
        
        guard (200...299).contains(
            httpResponse.statusCode
        ) else {
            
            throw NetworkError.serverError(
                httpResponse.statusCode
            )
        }
        
        return try JSONDecoder().decode(
            [User].self,
            from: data
        )
    }
}

//Now the dependency graph becomes:
//
//ViewController
//       ↓
//ViewModel
//       ↓
//UserServiceProtocol
//       ↓
//UserService
//       ↓
//NetworkClientProtocol
//       ↓
//NetworkClient
//       ↓
//URLSession
//       ↓
//API


//Dependency Mapping

//For a production application, I recommend understanding the dependency direction:

┌───────────────────┐
│       View        │
│ UIViewController  │
└─────────┬─────────┘
          │
          ▼
┌───────────────────┐
│     ViewModel     │
└─────────┬─────────┘
          │
          ▼
┌───────────────────┐
│     Protocol      │
└─────────┬─────────┘
          │
          ▼
┌───────────────────┐
│     Service       │
└─────────┬─────────┘
          │
          ▼
┌───────────────────┐
│ Network Protocol  │
└─────────┬─────────┘
          │
          ▼
     URLSession
