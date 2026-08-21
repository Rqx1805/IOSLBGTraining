import Foundation

// Model-

struct User {
    let id: Int
    let name: String
}

// Service-

// 1. Servive Protocol
protocol APIServiceProtocol {
    func fetchUser(completion: @escaping(Result<[User], Error) -> Void)
}

// 2. Servive Class

class APIServive: APIServiceProtocol {
    func fetchUser(completion: @escaping(Result<[User], Error) -> Void) {
        let users = [
            User(
                id: 1,
                name: "Ashish",
                email: "ashish@test.com"
            ),
            User(
                id: 2,
                name: "John",
                email: "john@test.com"
            )
        ]
        completion(.success(users))
    }
}

// View Model

class UserViewModel {
    var user: [User] = []
    var service: APIServiceProtocol
    
    init(service: APIServiceProtocol = APIServive()) {
        self.service = service
    }
    
    func fetchUser() {
        // Memory Management or Retail Cycle User weak self
        service.fetchUser { [weak self] result in
            switch result {
            case .success(let user):
                self.user = user
                completion(.success(()))
                self.updateUI(users)
            case .failure(let error):
                print(error)
                completion(.failure(error))
                self.showError(error)
            }
        }
    }
    
    private func updateUI(_ users: [User]) {
        print(users)
    }
    
    private func showError(_ error: Error) {
        print(error.localizedDescription)
    }
}

// Show data in viewController
class UserViewController: UIViewController {
    private let viewModel = UserViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fetchUser()
    }
}
