final class MockAPIService: APIServiceProtocol {
    
    var usersToReturn: [User] = []
    
    var shouldThrowError = false
    
    func fetchUser() async throws -> [User] {
        
        if shouldThrowError {
            throw APIError.invalidResponse
        }
        
        return usersToReturn
    }
}


import XCTest
@testable import AppName

@MainActor
final class UserListModelTests: XCTestCase {
    
    var mockAPIService: MockAPIService!
    var viewModel: UserListModel!
    
    override func setUp() {
        super.setUp()
        
        mockAPIService = MockAPIService()
        viewModel = UserListModel(apiService: mockAPIService)
    }
    
    override func tearDown() {
        viewModel = nil
        mockAPIService = nil
        
        super.tearDown()
    }
    
    func testFetchUserSuccess() async {
        
        // Given
        let expectedUsers = [User(id: 1, name: "Ashish", email: "ashish@test.com")]
        
        mockAPIService.usersToReturn = expectedUsers
        
        // When
        viewModel.fetchUser()
        
        // Wait for internal Task to complete
        try? await Task.sleep(for: .milliseconds(100))
        
        // Then
        XCTAssertEqual(viewModel.users.count, 1)
        XCTAssertEqual(viewModel.users.first.name, "Ashish")
    }
    
    func testFetchUserFailure() async {
        // Given
        mockAPIService.shouldThrowError = true
        // When
        await viewModel.fetchUser()
        // Then
        XCTAssertTrue(viewModel.users.isEmpty)
    }
    
    func testFetchUserEmptyResponse() async {
        // Given
        mockAPIService.usersToReturn = []
        // When
        await viewModel.fetchUser()
        // Then
        XCTAssertTrue(viewModel.users.isEmpty)
    }
}

