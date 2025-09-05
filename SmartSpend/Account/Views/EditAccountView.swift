import SwiftUI
import PhotosUI

struct EditAccountView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var userVM: UserViewModel

    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var username: String = ""
    @State private var avatarURL: String = ""

    // Photo picker
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImage: UIImage? = nil

    var body: some View {
        Form {
            Section("Avatar") {
                VStack {
                    if let image = selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            .shadow(radius: 3)
                    } else if let url = URL(string: avatarURL) {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .failure:
                                Image(systemName: "person.circle").font(.largeTitle)
                            case .success(let image):
                                image.resizable()
                            default:
                                ProgressView()
                            }
                        }
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                    }

                    PhotosPicker(
                        selection: $selectedItem,
                        matching: .images,
                        photoLibrary: .shared()
                    ) {
                        Text("Change Photo")
                            .foregroundStyle(Color.MainColor)
                    }
                    .onChange(of: selectedItem) { oldValue, newValue in
                        Task {
                            if let data = try? await newValue?.loadTransferable(type: Data.self),
                               let uiImage = UIImage(data: data) {
                                selectedImage = uiImage
                                // Optionally: convert to base64 string if backend accepts
                                // avatarURL = "data:image/png;base64,\(data.base64EncodedString())"
                            }
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
                        avatar_url: avatarURL.isEmpty ? nil : avatarURL,
                    )
                    await userVM.updateProfile(request)
                    dismiss()
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .foregroundStyle(.white)
            .listRowBackground(Color.MainColor)
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



//#Preview {
//    let vm = UserViewModel()
//    vm.currentUser = User(
//        first_name: "Refik",
//        last_name: "Jaija",
//        username: "refikj",
//        google_email: nil,
//        apple_email: nil,
//        avatar_url: "https://hws.dev/paul3.jpg",
//        balance: 120,
//        monthly_saving_goal: 50,
//        preferred_currency: .EUR
//    )
//
//    return NavigationStack {
//        EditAccountView()
//            .environmentObject(vm)   // ✅ inject the environment object
//    }
//}


#Preview {
    EditAccountView()
        .environmentObject(UserViewModel())
        
}
