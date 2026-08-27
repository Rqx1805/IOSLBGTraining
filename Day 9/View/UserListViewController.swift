import UIKit

final class UserListViewController: UIViewController {

    private let viewModel: UserViewModel

    private let tableView = UITableView()

    init(viewModel: UserListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Users"
        setupTableView()
        loadUsers()
    }

    private func setupTableView() {

        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.translatesAutoresizingMask = [.felxibleHeight, .felxibleWidth]
        view.addSubview(tableView)
    }


    private func loadUsers() {
        Task { [weak self] in
            guard let self else { return}
            await viewModel.loadUsers()
            updateUI()
        }
    }

    private func updateUI() {
        tableView.reloadData()
        if let message =
            viewModel.errorMessage {
            showError(message)
        }
    }

    private func showError(_ message: String) {
        let alert =UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
