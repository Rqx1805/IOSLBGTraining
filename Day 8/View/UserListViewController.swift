import UIKit

// Before refactoring, writes everything inside the ViewController.

// It may work, but there are architectural problems.

final class UserListViewController: UIViewController {

    private var users: [User] = []

    private let tableView = UITableView()

    override func viewDidLoad() {

        super.viewDidLoad()

        setupTableView()

        fetchUsers()
    }

    private func setupTableView() {

        tableView.frame = view.bounds

        tableView.dataSource = self

        view.addSubview(tableView)
    }

    private func fetchUsers() {

        guard let url = URL(
            string:
                "https://jsonplaceholder.typicode.com/users"
        ) else {
            return
        }

        URLSession.shared.dataTask(
            with: url
        ) { [weak self] data, response, error in

            guard
                let data,
                error == nil
            else {
                return
            }

            do {

                let users =
                    try JSONDecoder().decode(
                        [User].self,
                        from: data
                    )

                DispatchQueue.main.async {

                    self?.users = users

                    self?.tableView.reloadData()
                }

            } catch {
                print(error)
            }
        }
        .resume()
    }
}

//ViewController
// ├── Creates UI
// ├── Performs networking
// ├── Decodes JSON
// ├── Handles errors
// ├── Stores business state
// └── Updates table


// Refactoring — Step 1

// First separate networking.
