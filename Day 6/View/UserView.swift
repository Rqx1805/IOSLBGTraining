import SwiftUI

struct UserView: View {

    @StateObject private var viewModel = UserViewModel()

    //@StateObject vs @ObservedObject
    //StateObject -- Use it when the View creates and owns the ViewModel.
    
    //ObservedObject -- Use it when the ViewModel is created elsewhere and injected into the View.
    
    var body: some View {
        VStack(spacing: 16) {

            if viewModel.isLoading {
                ProgressView()
            } else if let user = viewModel.user {
                Text(user.name)
                    .font(.title)
            } else if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
            }

            Button("User Data") {
                Task {
                    await viewModel.fetchUser()
                }
            }
        }
        .padding()
    }
}

#Preview {
    UserView()
}
