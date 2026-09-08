//  UserListModel.swift

import Foundation

@MainActor
final class UserListModel: ObservableObject {
    
    @Published private(set) var users: [User] = []
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var errorMessage: String?
    
    private var apiService: APIServiceProtocol
    
    init(apiService: APIServiceProtocol = APIService()) {
        self.apiService = apiService
    }
    
    func fetchUser() {
        
        isLoading = true
        
        errorMessage = nil
        
        defer {
            isLoading = false
        }
        
        do {
            users = try await apiService.fetchUser()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
