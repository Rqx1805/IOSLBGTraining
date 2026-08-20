import Foundation

// 1. Declaring Optionals
// The question mark (?) indicates the variable can hold a String or be nil.
var jobTitle: String? = "iOS Developer"
var middleName: String? = nil // Explicitly has no value

print("Job: \(String(describing: jobTitle))")
print("Middle Name: \(String(describing: middleName))")


// 2. Unwrapping safely using 'if let' (Optional Binding)
if let actualJob = jobTitle {
    // Inside this block, actualJob is a regular, non-optional String
    print("Success! The person works as a \(actualJob).")
} else {
    print("The person is currently unemployed.")
}


// 3. Unwrapping safely using 'guard let'
func printMiddleName(name: String?) {
    guard let actualMiddleName = name else {
        print("No middle name provided. Exiting function.")
        return
    }
    // actualMiddleName is available for the rest of the function scope
    print("Middle name is: \(actualMiddleName)")
}
printMiddleName(name: middleName)


// 4. Providing a default value using Nil Coalescing (??)
let currentStatus = jobTitle ?? "Searching for a job..."
let passportName = middleName ?? "(N/A)"

print("Status: \(currentStatus)")
print("Passport Middle Name: \(passportName)")


// 5. Force Unwrapping (!)
// WARNING: Only use this if you are 100% sure the variable is not nil.
// If it is nil, your app WILL crash.
jobTitle = "Senior Engineer"
print("Force unwrapped job: \(jobTitle!)")

