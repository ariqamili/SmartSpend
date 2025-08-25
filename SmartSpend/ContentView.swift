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
            }else {
                
                LoginView()
            }
            
          }
        
        }
    
    
    }
    
    struct AddBottomSheetView: View {
        @State private var selected = 1
        
        var body: some View {
            VStack{
                Picker("Type of add", selection: $selected){
                    Text("Inceome").tag(1)
                    Text("Expense").tag(2)
                    
                }.pickerStyle(.segmented)
                    .padding()
                
                Spacer()
                if selected == 1{
                    
                    Button(action: {
                        
                    }) {
                        HStack {
                            Text("Add")
                                .foregroundStyle(.white)
                        }
                        .frame(maxWidth: .infinity, minHeight: 60)
                        .background(Color.MainColor)
                        .cornerRadius(12)
                        .shadow(radius: 2)
                    }
                    .padding()
                    
                } else if selected == 2{
                    VStack{
                        
                        
                        Button(action: {
                            
                        }) {
                            HStack {
                                Image(systemName: "camera")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 40)
                                    .foregroundStyle(.gray)
                                
                            }
                            .frame(maxWidth: .infinity, minHeight: 60)
                            .background(Color.white)
                            .cornerRadius(12)
                            .shadow(radius: 2)
                        }
                        .padding()
                        
                        
                        Button(action: {
                            
                        }) {
                            HStack {
                                Text("Add manually")
                                    .foregroundStyle(.white)
                            }
                            .frame(maxWidth: .infinity, minHeight: 60)
                            .background(Color.MainColor)
                            .cornerRadius(12)
                            .shadow(radius: 2)
                        }
                        .padding()
                        
                    }
                }
                
                Spacer()
                
            }

        }
    }
    
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
                .environmentObject(AuthenticationViewModel()) // inject for previews
        }
    }

