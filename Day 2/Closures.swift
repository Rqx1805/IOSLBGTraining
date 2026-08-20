import UIKit

// 1. Basic Closure Assignment
// This closure takes no parameters and returns nothing (Void).
let data = {
    print("Basic Closure")
}
// Calling the closure
data()

// 2. Closure with Parameters and Return Types
// The syntax inside the brackets specifies: (parameters) -> returnType in
let add = { (a: Int, b: Int) -> Int in
    return a + b
}

let result = add(10, 20)
print(result)

// 3. Passing a Closure as a Function Argument
// Functions can accept closures to run code after an action finishes.

func performMathOperation(a: Int, b: Int, operation: (Int, Int) -> Int) {
    let output = operation(a, b)
    print("The operation result is: \(output)")
}

// Inline closure passing
performMathOperation(a: 10, b: 5, operation: { (x, y) in
    return x + y
})

// 4. Trailing Closure Syntax & Shorthand Arguments
let arr = [1, 2, 3]
let result1 = arr.map { $0 * 2 }
print(result1)


// 5. Escaping Closures (@escaping)
// Used when a closure is stored or outlives the execution of the function (like network requests).

class NetworkManager {
    // Array to store closures for execution later
    var completionHandlers: [() -> Void] = []
    
    // The @escaping keyword is mandatory here because the closure is stored outside the function scope
    func downloadData(completion: @escaping () -> Void) {
        print("Starting download...")
        completionHandlers.append(completion) // Storing it for later execution
    }
    
    func simulatedDownloadFinished() {
        print("Download complete event fired.")
        // Execute the stored closure
        for handler in completionHandlers {
            handler()
        }
    }
}

let manager = NetworkManager()
manager.downloadData {
    print("UI Updated with downloaded data!")
}
// Simulating the delay/asynchronous trigger later on
manager.simulatedDownloadFinished()
