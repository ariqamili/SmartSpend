import SwiftUI

enum TabKey: Hashable { case home, add, account }

struct ContentView: View {
    @EnvironmentObject var authVM: AuthenticationViewModel
    @EnvironmentObject var userVM: UserViewModel
    @EnvironmentObject var categoryVM: CategoryViewModel
    @EnvironmentObject var transactionVM: TransactionViewModel
    
    @State private var selection: TabKey = .home
    @State private var lastNonAddSelection: TabKey = .home
    @State private var showAddSheet = false
    
    
    var body: some View {
        Group {
            if authVM.isSignedIn && userVM.isOnboarded {
                StartingScreenView(switchingView: mainTabView)
            } else if !authVM.isSignedIn{
                StartingScreenView(switchingView: LoginView())
            }
            else{
                OnboardView()
            }
            
        }
        .onChange(of: authVM.isSignedIn) { oldValue, newValue in
            if newValue {
                Task {
                    await userVM.fetchUser()
                    print("The current user: \(String(describing: userVM.currentUser))")
                   // await categoryVM.fetchCategories()
                }
            } else {
                // Clear cached user on sign out
                userVM.currentUser = nil
            }

        }

    }
    
    
    
     var mainTabView: some View {
        TabView(selection: $selection) {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .tag(TabKey.home)
            
            Text("") // Placeholder for Add button
                .tabItem {
                    Label("Add", systemImage: "plus.circle")
                }
                .tag(TabKey.add)
            
            AccountView()
                .tabItem {
                    Label("Account", systemImage: "person.crop.circle")
                }
                .tag(TabKey.account)
        }
        .tint(Color.MainColor)
        .onChange(of: selection) {
            if selection == .add {
                showAddSheet = true
                selection = lastNonAddSelection
            } else {
                lastNonAddSelection = selection
            }
        }
        .sheet(isPresented: $showAddSheet) {
            AddBottomSheetView(transactionVM: transactionVM, userVM: userVM, categoryVM: categoryVM)
                .environmentObject(transactionVM)
                .environmentObject(userVM)
                .environmentObject(categoryVM)
                .presentationDetents([.medium, .large])
        }
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(UserViewModel())
            .environmentObject(CategoryViewModel())
            .environmentObject(TransactionViewModel())
            .environmentObject(AuthenticationViewModel())
    }
}
