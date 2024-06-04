//
//  ProfileView.swift
//  spline-test
//
//  Created by Sachin Dhami on 6/3/24.
//
import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct User: Identifiable, Codable {
    let id: String
    var fullname: String
    var email: String
    var image: UIImage?

    var initials: String {
        let formatter = PersonNameComponentsFormatter()
        if let components = formatter.personNameComponents(from: fullname) {
            formatter.style = .abbreviated
            return formatter.string(from: components)
        }
        return ""
    }

    enum CodingKeys: String, CodingKey {
        case id, fullname, email
    }

    init(id: String, fullname: String, email: String, image: UIImage?) {
        self.id = id
        self.fullname = fullname
        self.email = email
        self.image = image
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        fullname = try container.decode(String.self, forKey: .fullname)
        email = try container.decode(String.self, forKey: .email)
        image = nil // You can't directly decode a UIImage from data, so it's set to nil here
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(fullname, forKey: .fullname)
        try container.encode(email, forKey: .email)
        // If you have a way to convert UIImage to Data and back, you can encode/decode image here
    }
}

struct ProfileView: View {
    @EnvironmentObject var viewMode: AuthViewModel

    @State private var user: User
    @State private var showImagePicker: Bool = false

    init(user: User) {
        self._user = State(initialValue: user)
    }

    var body: some View {
        VStack(spacing: 20) {
            profileImageView
            editNameField
            editEmailField
            Spacer()
            saveButton
            signOutButton
        }
        .padding()
    }

    private var profileImageView: some View {
        VStack {
            if let image = user.image {
                Image(uiImage: image)
                    .resizable()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .onTapGesture { showImagePicker = true }
            } else {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.gray)
                    .onTapGesture { showImagePicker = true }
            }
            Text("Click to edit")
                .font(.custom("OktahRound-Md", size: 14))
                .foregroundColor(.gray)
        }
        .padding(.top, 20)
        .sheet(isPresented: $showImagePicker) {
//            ImagePicker(image: $user.image)
        }
    }

    private var editNameField: some View {
        TextField("Enter your name", text: $user.fullname)
            .font(.custom("OktahRound-BdIt", size: 24))
            .multilineTextAlignment(.center)
            .textFieldStyle(RoundedBorderTextFieldStyle())
    }

    private var editEmailField: some View {
        TextField("Enter your email", text: $user.email)
            .font(.custom("OktahRound-Md", size: 18))
            .textFieldStyle(RoundedBorderTextFieldStyle())
    }

    private var saveButton: some View {
        Button(action: saveProfile) {
            Text("Save")
                .font(.custom("OktahRound-BdIt", size: 24))
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.green)
                .cornerRadius(10)
        }
        .padding(.bottom, 40)
    }

    private var signOutButton: some View {
        Button(action: signOut) {
            Text("Sign Out")
                .font(.custom("OktahRound-BdIt", size: 24))
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.red) // Adjust color as needed
                .cornerRadius(10)
        }
    }

    private func saveProfile() {
        guard let userID = Auth.auth().currentUser?.uid else {
            print("Error: Could not get current user ID")
            return
        }

        let db = Firestore.firestore()
        let userRef = db.collection("users").document(userID)

        let userData = [
            "fullname": user.fullname,
            "email": user.email,
        ]

        userRef.setData(userData) { error in
            if let error = error {
                print("Error saving user data: \(error.localizedDescription)")
            } else {
                print("Profile saved successfully!")
            }
        }
    }

    private func signOut() {
        do {
            try Auth.auth().signOut()
            viewMode.isSignedOut = true
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
}


//struct ProfileView_Previews: PreviewProvider {
//    static var previews: some View {
////        ProfileView(user: User ?? User(id: "", fullname: "", email: "", image: nil))
//        ProfileView(user: User)
//    }
//}

//
//import SwiftUI
//import FirebaseAuth
//import FirebaseFirestore
//
//
//struct User: Identifiable, Codable {
//  let id: String
//  var fullname: String
//  var email: String
//  var image: UIImage?
//
//  var initials: String {
//    let formatter = PersonNameComponentsFormatter()
//    if let components = formatter.personNameComponents(from: fullname) {
//      formatter.style = .abbreviated
//      return formatter.string(from: components)
//    }
//    return ""
//  }
//
//  enum CodingKeys: String, CodingKey {
//    case id, fullname, email
//  }
//
//  init(id: String, fullname: String, email: String, image: UIImage?) {
//    self.id = id
//    self.fullname = fullname
//    self.email = email
//    self.image = image
//  }
//
//
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        id = try container.decode(String.self, forKey: .id)
//        fullname = try container.decode(String.self, forKey: .fullname)
//        email = try container.decode(String.self, forKey: .email)
//        image = nil // You can't directly decode a UIImage from data, so it's set to nil here
//    }
//
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(id, forKey: .id)
//        try container.encode(fullname, forKey: .fullname)
//        try container.encode(email, forKey: .email)
//        // If you have a way to convert UIImage to Data and back, you can encode/decode image here
//    }
//}
//
//struct ProfileView: View {
//    
//    static let MOCK_USER = User(id: "123", fullname: "John Doe", email: //"johndoe@example.com", image: nil)
//
//    struct SettingsRowView: View { // Nested definition
//        let imageName: String
//        let title: String
//        let tintColor: Color
//
//        var body: some View {
//            HStack {
//                Image(systemName: imageName)
//                    .foregroundColor(tintColor)
//                Text(title)
//            }
//        }
//    }
//
//    var body: some View {
//        List {
//            Section {
//                HStack {
//                    // Profile image with initials
//                    Text(ProfileView.MOCK_USER.initials)
//                        .font(.title)
//                        .fontWeight(.semibold)
//                        .foregroundColor(.white)
//                        .frame(width: 72, height: 72)
//                        .background(Color.darkPurple)
//                        .clipShape(Circle())
//
//                    VStack(alignment: .leading, spacing: 4) {
//                        Text(ProfileView.MOCK_USER.fullname)
//                            .font(.subheadline)
//                            .fontWeight(.semibold)
//                            .padding(.top, 4)
//
//                        Text(ProfileView.MOCK_USER.email)
//                            .font(.footnote)
//                            .foregroundColor(.gray)
//                    }
//                }
//            }
//
//            Section("General") {
//                HStack {
//                    SettingsRowView(imageName: "gear", title: "Version", tintColor: Color.darkPurple)
//                    Spacer()
//                    Text("1.0.0")
//                        .font(.subheadline)
//                        .foregroundColor(.gray)
//                }
//            }
//
//            Section("Account") {
//                Button {
//                    print("Sign Out...")
//                } label: {
//                    SettingsRowView(imageName: "arrow.left.circle.fill", title: "Sign Out", tintColor: .red)
//                }
//
//                Button {
//                    print("Delete Account...")
//                } label: {
//                    SettingsRowView(imageName: "xmark.circle.fill", title: "Delete Account", tintColor: .red)
//                }
//            }
//        }
//        .listStyle(.insetGrouped) // Optional: Set the list style
//    }
//}
//
//struct ProfileView_Previews: PreviewProvider {
//    static var previews: some View { ProfileView() }
//}
