//
//  ProfileView.swift
//  spline-test
//
//  Created by Sachin Dhami on 6/3/24.
//
import SwiftUI

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
        }
        .padding()
        .background(Color.blue.edgesIgnoringSafeArea(.all))
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
            ImagePicker(image: $user.image)
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

    private func saveProfile() {
        // Code to save the profile information
        print("Profile saved!")
        print("Name: \(user.fullname)")
        print("Email: \(user.email)")
        // Handle image saving if needed
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Environment(\.presentationMode) var presentationMode

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker

        init(parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }
            parent.presentationMode.wrappedValue.dismiss()
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}

let sampleUser = User(id: "1", fullname: "John Doe", email: "johndoe@example.com", image: nil)

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(user: sampleUser)
    }
}



