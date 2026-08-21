import Foundation

// MARK: - 1. Declaring Optionals

// The question mark (?) means the variable can hold a String or nil.
var jobTitle: String? = "iOS Developer"

// No need to explicitly assign nil.
// Optional variables are nil by default.
var middleName: String?

print("Job: \(String(describing: jobTitle))")
print("Middle Name: \(String(describing: middleName))")


// MARK: - 2. Optional Binding using if let

// No need to create a separate variable if you only need to check
// whether jobTitle contains a value.
if let jobTitle {
    print("Success! The person works as a \(jobTitle).")
} else {
    print("The person is currently unemployed.")
}


// MARK: - 3. Optional Binding using guard let

func printMiddleName(name: String?) {
    guard let name else {
        print("No middle name provided. Exiting function.")
        return
    }

    print("Middle name is: \(name)")
}

printMiddleName(name: middleName)


// MARK: - 4. Providing a Default Value using Nil Coalescing (??)

let currentStatus = jobTitle ?? "Searching for a job..."
let passportName = middleName ?? "(N/A)"

print("Status: \(currentStatus)")
print("Passport Middle Name: \(passportName)")


// MARK: - 5. Avoid Force Unwrapping (!)

jobTitle = "Senior Engineer"

// Safely unwrap instead of using jobTitle!
if let jobTitle {
    print("Job: \(jobTitle)")
}
