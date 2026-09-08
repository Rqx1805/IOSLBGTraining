//  UserListModel.swift

import Foundation

@MainActor
final class UserListModel: ObservableObject {
    @Published var users: [User] = []
    private var apiService: APIServiceProtocol
    
    init(apiService: APIServiceProtocol = APIService()) {
        self.apiService = apiService
    }
    
    var isloading: Bool = false
    
    func fetchUser() {
        Task {
            do {
                users = try await apiService.fetchUser()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
