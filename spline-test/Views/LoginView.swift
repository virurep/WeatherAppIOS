//
//  LoginView.swift
//  spline-test
//
//  Created by Gagan Singh on 6/3/24.
//
import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @EnvironmentObject var viewModel: AuthViewModel
    @Binding var isLoggedIn: Bool // Step 1: Binding for authentication state
    
    var body: some View {
        NavigationView {
            VStack(alignment: .center) {
                // Image
                Image("chicken no background")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 120, height: 150)
                    .padding(.vertical, 30)
                
                // Form fields
                VStack(spacing: 24) {
                    InputView(text: $email,
                              title: "Email Address",
                              placeholder: "name@example.com")
                        .autocapitalization(.none)
                    
                    InputView(text: $password,
                              title: "Password",
                              placeholder: "Enter your password",
                              isSecureField: true)
                        .autocapitalization(.none)
                }
                .padding(.horizontal)
                .padding(.top, 12)
                
                // Sign in button
                Button {
                    Task {
                        do {
                            try await viewModel.signIn(withEmail: email, password: password)
                            // Step 2: Update authentication state upon successful login
                            isLoggedIn = true
                        } catch {
                            // Handle error
                            print("Error: \(error)")
                        }
                    }
                } label: {
                    HStack {
                        Text("Sign In")
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                        Image(systemName: "arrow.right")
                    }
                }
                .frame(width: UIScreen.main.bounds.width - 64, height: 56)
                .padding(.horizontal)
                .background(Color.blue)
                .cornerRadius(10)
                .shadow(radius: 5)
                .padding(.top, 24)
                
                Spacer()
                
                // Sign up link
                NavigationLink(destination: RegistrationView().navigationBarBackButtonHidden(true)) {
                    HStack(spacing: 3) {
                        Text("Don't have an account?")
                        Text("Sign Up")
                            .fontWeight(.bold)
                    }
                    .font(.system(size: 14))
                }
            }
            .padding(.horizontal)
            .navigationBarTitle("Login")
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(isLoggedIn: .constant(false)) // Step 3: Pass binding for authentication state
            .environmentObject(AuthViewModel()) // Assuming you need to provide AuthViewModel
    }
}
