import Foundation

// MARK: - 1. Basic Closure Assignment

// This closure takes no parameters and returns Void.
func basicClosure() {
    let data = {
        print("Basic Closure")
    }
    
    // Calling the closure
    data()
}

// MARK: - 2. Closure with Parameters

func closureWithParameters() {
    let userData = { (name: String) in
        print("HI, \(name)")
    }
    
    userData("Ashish")
}


// MARK: - 3. Closure with Parameters and Return Type

// Swift can infer parameter types and return type.
func closureWithReturnValue() {
    let addNumbers = { (a: Int, b: Int) -> Int in // Input - int , output int
        return a + b
    }
    
    let result = addNumbers(10, 20)
    print("Sum: \(result)")
}

// $0 and $1 are shorthand argument names.
func closureWithReturnValue() {
    let add: (Int, Int) -> Int = {
        $0 + $1
    }
    
    let result = add(10, 20)
    
    print(result)
}

// MARK: - 5. Closure Type
func closureWithReturnValue() {
    let add: (Int, Int) -> Int = { a, b in
        return a + b
    }
    
    print("result: \(add(10,20))")
}



// MARK: - 6. Passing a Closure as a Function Argument

func performMathOperation(
    a: Int,
    b: Int,
    operation: (Int, Int) -> Int
) {
    let output = operation(a, b)
    print("The operation result is: \(output)")
}

// Using shorthand arguments and implicit return
performMathOperation(a: 10, b: 5) {
    $0 + $1
}


// MARK: - 7. Trailing Closure Syntax & Shorthand Arguments

let arr = [1, 2, 3]

let result1 = arr.map {
    $0 * 2
}

print(result1)

func trailingClosure() {
    performOperation(a: 20, b: 10) { a, b in
        return a - b
    }
}



// MARK: - 8. Escaping Closures

protocol DataDownloading {
    func downloadData(completion: @escaping () -> Void)
}

func downloadData(
    completion: @escaping (String) -> Void
) {
    DispatchQueue.main.async {
        completion("Data fetched successfully")
    }
}



// MARK: - 9. Capture List

func captureList() {
    var userCount = 0
    
    let increment = { [userCount] in
        print("Captured User Count: \(userCount)")
    }
    
    count = 2
    
    increment()
}


// MARK: - NetworkManager

final class NetworkManager: DataDownloading {
    
    // Private for encapsulation
    private var completionHandlers: [() -> Void] = []
    
    func downloadData(completion: @escaping () -> Void) {
        print("Starting download...")
        
        // The closure escapes because it is stored
        completionHandlers.append(completion)
    }
    
    func simulatedDownloadFinished() {
        print("Download complete event fired.")
        
        completionHandlers.forEach { handler in
            handler()
        }
        
        // Clear stored closures after execution
        completionHandlers.removeAll()
    }
}


// MARK: - ViewModel / Consumer

final class ViewModel {
    
    private let networkManager: DataDownloading
    
    init(networkManager: DataDownloading) {
        self.networkManager = networkManager
    }
    
    func fetchData() {
        networkManager.downloadData { [weak self] in
            guard let self else {
                return
            }
            
            self.updateUI()
        }
    }
    
    private func updateUI() {
        print("UI Updated with downloaded data!")
    }
}


// MARK: - Usage

let manager = NetworkManager()
let viewModel = ViewModel(networkManager: manager)

viewModel.fetchData()

manager.simulatedDownloadFinished()
