import UIKit

// ============================================================
// MARK: - Model
// ============================================================

struct User: Decodable {

    let id: Int
    let name: String
    let email: String
}


// ============================================================
// MARK: - Network Layer
// ============================================================

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case statusCode(Int)
    case decodingError(Error)
   
}


// ============================================================
// MARK: - API Service Protocol
//
// Dependency inversion:
// ViewModel depends on this abstraction,
// not on a concrete networking implementation.
// ============================================================

protocol UserServiceProtocol {

    func fetchUsers() async throws -> [User]
}


// ============================================================
// MARK: - API Service
//
// Responsible only for networking.
// ============================================================

final class UserService: UserServiceProtocol {

    private let session: URLSession
    private let baseURL = "https://jsonplaceholder.typicode.com"

    init(session: URLSession = .shared) {
        self.session = session
    }

    func fetchUsers() async throws -> [User] {

        // `guard` avoids force unwrapping the URL.
        guard let url = URL(
            string: "\(baseURL)/users"
        ) else {
            throw NetworkError.invalidURL
        }

        let (data, response) = try await session.data(
            from: url
        )

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.serverError(
                httpResponse.statusCode
            )
        }

        do {
            return try JSONDecoder().decode(
                [User].self,
                from: data
            )
        } catch {
            throw NetworkError.decodingFailed
        }
    }
}


// ============================================================
// MARK: - ViewModel
//
// Responsible for:
// - State
// - Business logic
// - Calling the service
//
// It does NOT create the UserService itself.
// This makes the ViewModel testable.
// ============================================================

@MainActor
final class UserListViewModel {

    // MARK: State

    private(set) var users: [User] = []

    private(set) var isLoading = false

    private(set) var errorMessage: String?

    // MARK: Dependency

    private let service: any UserServiceProtocol

    // MARK: Initialization

    init(service: any UserServiceProtocol) {
        self.service = service
    }

    // MARK: Public Methods

    func loadUsers() async {

        isLoading = true
        errorMessage = nil

        defer {
            isLoading = false
        }

        do {

            users = try await service.fetchUsers()

        } catch let error as NetworkError {

            handle(error)

        } catch {

            errorMessage = "Something went wrong."
        }
    }

    // MARK: Private Methods

    private func handle(_ error: NetworkError) {

        switch error {

        case .invalidURL:
            errorMessage = "Invalid URL."

        case .invalidResponse:
            errorMessage = "Invalid server response."

        case .decodingError(let error):
            errorMessage = "Unable to process server data: \(error)"

        case .statusCode(let statusCode):
            errorMessage = "Server error: \(statusCode)"
        }
    }
}


// ============================================================
// MARK: - Custom TableView Cell
// ============================================================

final class UserTableViewCell: UITableViewCell {

    static let reuseIdentifier = "UserTableViewCell"

    private let nameLabel = UILabel()
    private let emailLabel = UILabel()

    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(
            style: style,
            reuseIdentifier: reuseIdentifier
        )

        setupUI()
    }

    required init?(
        coder: NSCoder
    ) {
        super.init(coder: coder)

        setupUI()
    }

    private func setupUI() {

        nameLabel.font = .preferredFont(
            forTextStyle: .headline
        )

        emailLabel.font = .preferredFont(
            forTextStyle: .subheadline
        )

        emailLabel.textColor = .secondaryLabel

        let stackView = UIStackView(
            arrangedSubviews: [
                nameLabel,
                emailLabel
            ]
        )

        stackView.axis = .vertical
        stackView.spacing = 4

        contentView.addSubview(stackView)

        stackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([

            stackView.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: 12
            ),

            stackView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: 16
            ),

            stackView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -16
            ),

            stackView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -12
            )
        ])
    }

    func configure(with user: User) {

        nameLabel.text = user.name
        emailLabel.text = user.email
    }
}


// ============================================================
// MARK: - ViewController
//
// Responsible only for:
// - UI
// - User interaction
// - Displaying ViewModel state
//
// Business/networking logic stays outside the ViewController.
// ============================================================

final class UserListViewController: UIViewController {

    // MARK: Constants

    private enum Constants {

        static let title = "Users"

        static let loadingMessage = "Loading users..."

        static let errorTitle = "Error"

        static let okTitle = "OK"

        static let cellHeight: CGFloat = 70
    }

    // MARK: UI

    private let tableView = UITableView()

    private let activityIndicator = UIActivityIndicatorView(
        style: .large
    )

    // MARK: ViewModel

    private let viewModel: UserListViewModel

    // MARK: Initialization

    init(viewModel: UserListViewModel) {

        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    required init?(
        coder: NSCoder
    ) {
        fatalError(
            "init(coder:) has not been implemented"
        )
    }

    // MARK: Lifecycle

    override func viewDidLoad() {

        super.viewDidLoad()

        setupUI()

        loadUsers()
    }

    // MARK: UI Setup

    private func setupUI() {

        title = Constants.title

        view.backgroundColor = .systemBackground

        setupTableView()

        setupActivityIndicator()
    }

    private func setupTableView() {

        tableView.dataSource = self

        tableView.register(
            UserTableViewCell.self,
            forCellReuseIdentifier:
                UserTableViewCell.reuseIdentifier
        )

        tableView.rowHeight = Constants.cellHeight

        view.addSubview(tableView)

        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([

            tableView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor
            ),

            tableView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor
            ),

            tableView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor
            ),

            tableView.bottomAnchor.constraint(
                equalTo: view.bottomAnchor
            )
        ])
    }

    private func setupActivityIndicator() {

        view.addSubview(activityIndicator)

        activityIndicator.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([

            activityIndicator.centerXAnchor.constraint(
                equalTo: view.centerXAnchor
            ),

            activityIndicator.centerYAnchor.constraint(
                equalTo: view.centerYAnchor
            )
        ])
    }

    // MARK: Data

    private func loadUsers() {

        Task { [weak self] in

            guard let self else {
                return
            }

            await viewModel.loadUsers()

            updateUI()
        }
    }

    // MARK: UI Updates

    private func updateUI() {

        if viewModel.isLoading {

            activityIndicator.startAnimating()

        } else {

            activityIndicator.stopAnimating()
        }

        tableView.reloadData()

        if let errorMessage = viewModel.errorMessage {

            showError(message: errorMessage)
        }
    }

    private func showError(
        message: String
    ) {

        let alert = UIAlertController(
            title: Constants.errorTitle,
            message: message,
            preferredStyle: .alert
        )

        alert.addAction(
            UIAlertAction(
                title: Constants.okTitle,
                style: .default
            )
        )

        present(alert, animated: true)
    }
}


// ============================================================
// MARK: - UITableViewDataSource
// ============================================================

extension UserListViewController:
    UITableViewDataSource {

    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {

        viewModel.users.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(
            withIdentifier:
                UserTableViewCell.reuseIdentifier,
            for: indexPath
        ) as? UserTableViewCell else {

            return UITableViewCell()
        }

        let user = viewModel.users[indexPath.row]

        cell.configure(with: user)

        return cell
    }
}


// ============================================================
// MARK: - Dependency Injection
//
// Composition root:
//
// Concrete service is created here and injected into
// the ViewModel.
//
// ViewController receives the ViewModel.
//
// This avoids tight coupling.
// ============================================================

let userService: any UserServiceProtocol =
    UserService()

let userViewModel = UserListViewModel(
    service: userService
)

let userViewController = UserListViewController(
    viewModel: userViewModel
)
