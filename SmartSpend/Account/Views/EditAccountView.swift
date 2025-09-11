import SwiftUI

struct EditAccountView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var userVM: UserViewModel

    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var username: String = ""
    @State private var avatarURL: String = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var showAvatarPicker = false 

    // Lorelei avatar seeds
    let avatarSeeds: [String] = ["Alice","Bob","Charlie","Dana","Eli","Fiona","George","Hana","Ivan","Julia"]
    var avatarOptions: [String] {
        avatarSeeds.map { seed in
            "https://api.dicebear.com/9.x/lorelei/png?seed=\(seed)"
        }
    }

    var body: some View {
        Form {
            Section("Avatar") {
                VStack {
                    if let url = URL(string: avatarURL) {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .failure(_):
                                Image(systemName: "person.circle").font(.largeTitle)
                            case .success(let image):
                                image.resizable().scaledToFill()
                            default:
                                ProgressView()
                            }
                        }
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .shadow(radius: 3)
                    }

                    Button("Choose Avatar") {
                        withAnimation {
                            showAvatarPicker.toggle()
                        }
                    }
                    .foregroundStyle(Color.MainColor)

                    if showAvatarPicker {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 15) {
                                ForEach(avatarOptions, id: \.self) { option in
                                    AsyncImage(url: URL(string: option)) { phase in
                                        switch phase {
                                        case .failure(_):
                                            Image(systemName: "person.circle.fill")
                                                .resizable()
                                                .scaledToFill()
                                        case .success(let image):
                                            image.resizable().scaledToFill()
                                        default:
                                            ProgressView()
                                        }
                                    }
                                    .frame(width: 60, height: 60)
                                    .clipShape(Circle())
                                    .overlay(
                                        Circle().stroke(avatarURL == option ? Color.MainColor : .clear, lineWidth: 3)
                                    )
                                    .onTapGesture {
                                        avatarURL = option
                                        showAvatarPicker = false
                                    }
                                }
                            }
                            .padding(.vertical, 5)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }

            Section("Personal Info") {
                TextField("First Name", text: $firstName)
                TextField("Last Name", text: $lastName)
                TextField("Username", text: $username)
            }

            Button("Save") {
                Task {
                    let request = UpdateUserRequest(
                        first_name: firstName.isEmpty ? nil : firstName,
                        last_name: lastName.isEmpty ? nil : lastName,
                        username: username.isEmpty ? nil : username,
                        avatar_url: avatarURL.isEmpty ? nil : avatarURL
                    )
                    await userVM.updateProfile(request)
                    dismiss()
                    await userVM.fetchUser()
                    
                    alertMessage = "Profile updated successfully!"
                    showAlert = true
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .foregroundStyle(.white)
            .listRowBackground(Color.MainColor)
            .alert("Result", isPresented: $showAlert) {
                Button("OK", role: .cancel) { dismiss() }
            } message: {
                Text(alertMessage)
            }
        }
        .navigationTitle("Edit Profile")
        .onAppear {
            if let user = userVM.currentUser {
                firstName = user.first_name
                lastName = user.last_name
                username = user.username
                avatarURL = user.avatar_url ?? ""
            }
        }
    }
}

#Preview {
    EditAccountView()
        .environmentObject(UserViewModel())

}
