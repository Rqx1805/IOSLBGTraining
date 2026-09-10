//  ContentView.swift

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = UserListModel()
    var body: some View {
        Group {
            if let errorView = viewModel.errorMessage {
                VStack(spacing: 12) {
                    Text("Something went wrong")
                    .font(.headline)
                    Text(errorView)
                    .foregroundStyle(.secondary)
                    Button("Retry") {
                        Task {
                            await viewModel.fetchUser()
                        }
                    }
                } .padding()
            } else {
                List(viewModel.users) { user in
                    VStack {
                        Text(user.name)
                        Text(user.email)
                    }
                    .padding()
                }
            }
        }
        .task {
            await viewModel.fetchUser()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
