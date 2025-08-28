import SwiftUI

enum TabKey: Hashable { case home, add, account }

struct ContentView: View {
    @EnvironmentObject var authVM: AuthenticationViewModel
    
    @State private var selection: TabKey = .home
    @State private var lastNonAddSelection: TabKey = .home
    @State private var showAddSheet = false
    
    
    var body: some View {
        
        
        Group {
            if authVM.isSignedIn {
                
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
                    if selection == .add  {
                        showAddSheet = true
                        selection = lastNonAddSelection
                    } else {
                        lastNonAddSelection = selection
                    }
                }
                .sheet(isPresented: $showAddSheet) {
                    AddBottomSheetView()
                        .presentationDetents([.medium, .large])
                }
            } else {
                
                LoginView()
            }
            
          }
        
        }
    
    
    }
    
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
                .environmentObject(AuthenticationViewModel()) // inject for previews
        }
    }

