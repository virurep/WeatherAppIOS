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
        VStack(alignment: .center, spacing: 20) {
            // Profile Image
            VStack {
                if let image = profileImage {
                    Image(uiImage: image)
                        .resizable()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .onTapGesture {
                            showImagePicker = true
                        }
                } else {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .foregroundColor(Color.darkPurple)
                        .onTapGesture {
                            showImagePicker = true
                        }
                }
                Text("Click to edit")
                    .font(.custom("OktahRound-Md", size: 14))
                    .foregroundColor(Color.gray)
            }
            .padding(.top, 60)
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(image: $profileImage)
            }
            
            // Editable Name
            TextField("Enter your name", text: $name)
                .font(.custom("OktahRound-BdIt", size: 32))
                .foregroundColor(Color.darkPurple)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 16)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            // Editable Email for user
            TextField("Enter your email", text: $email)
                .font(.custom("OktahRound-Md", size: 18))
                .foregroundColor(Color.darkPurple)
                .padding(.horizontal, 16)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            // Editable Password
            HStack {
                if isPasswordVisible {
                    TextField("Enter your password", text: $password)
                        .font(.custom("OktahRound-Md", size: 18))
                        .foregroundColor(Color.darkPurple)
                        .padding(.horizontal, 16)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                } else {
                    SecureField("Enter your password", text: $password)
                        .font(.custom("OktahRound-Md", size: 18))
                        .foregroundColor(Color.darkPurple)
                        .padding(.horizontal, 16)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                Toggle(isOn: $isPasswordVisible) {
                    Text("Show Password")
                        .font(.custom("OktahRound-Md", size: 14))
                        .foregroundColor(Color.gray)
                }
                .padding(.horizontal, 16)
            }
            
            // Preferred Locations section
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
                        
                        Button(action: {
                            removeLocation(location)
                        }) {
                            Image(systemName: "minus.circle.fill")
                                .foregroundColor(Color.darkPurple)
                        }
                    }
                    .padding(.horizontal, 16)
                }
                
                HStack {
                    TextField("Add new location", text: $newLocation)
                        .font(.custom("OktahRound-Md", size: 16))
                        .foregroundColor(Color.darkPurple)
                        .padding(.horizontal, 16)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(maxWidth: .infinity) // Added to make text field expand to full width
                    
                    Button(action: addLocation) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(Color.white)
                            .background(Color.darkPurple)
                            .clipShape(Circle())
                    }
                }
                .padding(.horizontal, 16)
            }
            .padding(.horizontal, 16)
            
            Spacer()
            
            // Save Button
            Button(action: saveProfile) {
                Text("Save")
                    .font(.custom("OktahRound-BdIt", size: 24))
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.darkPurple)
                    .cornerRadius(10)
                    .padding(.horizontal, 16)
            }
            .padding(.bottom, 20)
        }
        .background(Color.customBlue.edgesIgnoringSafeArea(.all))
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

// using image picker to update profile pic
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
