//
//  ProfileView.swift
//  spline-test
//
//  Created by Sachin Dhami on 6/3/24.
//
import SwiftUI

struct ProfileView: View {
    @State private var name: String = "John Doe"
    @State private var email: String = "johndoe@example.com"
    @State private var password: String = "password123"
    @State private var isPasswordVisible: Bool = false
    @State private var profileImage: UIImage? = UIImage(systemName: "person.circle.fill")
    @State private var showImagePicker: Bool = false
    @State private var locations: [String] = ["New York, USA", "San Francisco, USA", "Tokyo, Japan"]
    @State private var newLocation: String = ""

    var body: some View {
        VStack(spacing: 20) {
            profileImageView
            editNameField
            editEmailField
            editPasswordField
            preferredLocationsSection
            Spacer()
            saveButton
        }
        .padding()
        .background(Color.customBlue.edgesIgnoringSafeArea(.all))
    }

    private var profileImageView: some View {
        VStack {
            if let image = profileImage {
                Image(uiImage: image)
                    .resizable()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .onTapGesture { showImagePicker = true }
            } else {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .foregroundColor(Color.darkPurple)
                    .onTapGesture { showImagePicker = true }
            }
            Text("Click to edit")
                .font(.custom("OktahRound-Md", size: 14))
                .foregroundColor(.darkPurple)
        }
        .padding(.top, 20)
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(image: $profileImage)
        }
    }

    private var editNameField: some View {
        TextField("Enter your name", text: $name)
            .font(.custom("OktahRound-BdIt", size: 24))
            .foregroundColor(Color.darkPurple)
            .multilineTextAlignment(.center)
            .textFieldStyle(RoundedBorderTextFieldStyle())
    }

    private var editEmailField: some View {
        TextField("Enter your email", text: $email)
            .font(.custom("OktahRound-Md", size: 18))
            .foregroundColor(Color.darkPurple)
            .textFieldStyle(RoundedBorderTextFieldStyle())
    }

    private var editPasswordField: some View {
        HStack {
            if isPasswordVisible {
                TextField("Enter your password", text: $password)
                    .font(.custom("OktahRound-Md", size: 18))
                    .foregroundColor(Color.darkPurple)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            } else {
                SecureField("Enter your password", text: $password)
                    .font(.custom("OktahRound-Md", size: 18))
                    .foregroundColor(Color.darkPurple)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            Button(action: { isPasswordVisible.toggle() }) {
                Image(systemName: isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                    .foregroundColor(.darkPurple)
            }
            .padding(.horizontal)
        }
    }

    private var preferredLocationsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Preferred Locations")
                .font(.custom("OktahRound-BdIt", size: 24))
                .foregroundColor(Color.darkPurple)

            ForEach(locations, id: \.self) { location in
                HStack {
                    Text(location)
                        .font(.custom("OktahRound-Md", size: 16))
                        .foregroundColor(Color.darkPurple)
                    Spacer()
                    Button(action: { removeLocation(location) }) {
                        Image(systemName: "minus.circle.fill")
                            .foregroundColor(Color.darkPurple)
                    }
                }
                .padding(.horizontal)
            }

            HStack {
                TextField("Add new location", text: $newLocation)
                    .font(.custom("OktahRound-Md", size: 16))
                    .foregroundColor(Color.darkPurple)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button(action: addLocation) {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(.white)
                        .background(Color.darkPurple)
                        .clipShape(Circle())
                }
                .padding(.horizontal)
            }
        }
        .padding(.horizontal)
    }

    private var saveButton: some View {
        Button(action: saveProfile) {
            Text("Save")
                .font(.custom("OktahRound-BdIt", size: 24))
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.darkPurple)
                .cornerRadius(10)
        }
        .padding(.bottom, 40)
    }

    private func addLocation() {
        guard !newLocation.isEmpty else { return }
        locations.append(newLocation)
        newLocation = ""
    }

    private func removeLocation(_ location: String) {
        locations.removeAll { $0 == location }
    }

    private func saveProfile() {
        // Code to save the profile information
        print("Profile saved!")
        print("Name: \(name)")
        print("Email: \(email)")
        print("Password: \(password)")
        print("Locations: \(locations.joined(separator: ", "))")
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

#Preview {
    ProfileView()
}


