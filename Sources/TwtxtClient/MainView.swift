import SwiftUI

struct MainView: View {
    @StateObject var viewModel = TwtxtViewModel()
    @State private var selectedAccount: User?

    var body: some View {
        NavigationView {
		List(viewModel.accounts, id: \.id) { account in
    HStack {
        if let avatarURL = account.avatar {
            AsyncImageView(url: avatarURL)
            Text(account.nick)
        } else {
            Text("⚠️ No Avatar")
        }
    }
    .onTapGesture {
        print("🔍 Avatar URL for \(account.nick): \(account.avatar?.absoluteString ?? "None")")
        selectedAccount = account
        Task {
            await viewModel.fetchTwtxtFile(from: account.url)
        }
    }
}


/*
            List(viewModel.accounts, id: \.id) { account in
                HStack {
                    AsyncImageView(url: account.avatar) // Show avatar
                    Text(account.nick)
                        .font(.headline)
                }
                .onTapGesture {
                    selectedAccount = account
                    Task {
                        await viewModel.fetchTwtxtFile(from: account.url)
                    }
                }
            }
	    */
            .frame(minWidth: 250)
            .toolbar {
                Button(action: {
                    viewModel.showAddAccountDialog = true
                }) {
                    Image(systemName: "plus")
                }
            }

            if let selectedAccount = selectedAccount {
                TimelineView(posts: viewModel.posts, user: selectedAccount)
            } else {
                Text("Select an account to view posts.")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.gray.opacity(0.1))
            }
        }
        .sheet(isPresented: $viewModel.showAddAccountDialog) {
            AddAccountView(viewModel: viewModel)
        }
    }
}
