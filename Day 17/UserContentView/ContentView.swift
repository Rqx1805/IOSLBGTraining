//  ContentView.swift

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = UserListModel()
    var body: some View {
        List(viewModel.users) { user in
            VStack {
                Text(user.name)
                Text(user.email)
            }
            .padding()
        }
        .onAppear() {
            viewModel.fetchUser()
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
