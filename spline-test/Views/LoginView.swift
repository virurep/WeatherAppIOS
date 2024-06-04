//
//  LoginView.swift
//  spline-test
//
//  Created by Gagan Singh on 6/3/24.
//

import Foundation
import SwiftUI
struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .center){
                //image
                Image("chicken no background")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 120, height: 150)
                    .padding(.vertical, 30)
                
                
                //form fields
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
                
                //sign in
                Button {
                    print("Sign user in...")
                } label: {
                    HStack {
                        Text("Sign In")
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                        
                        Image(systemName: "arrow.right")
                            .foregroundColor(.white)
                        
                    }
                    .frame(width: UIScreen.main.bounds.width - 64, height: 56)
                    .padding(.horizontal)
                    .background(Color.blue)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .padding(.top, 24)
                }
                
                
                
                
                
                Spacer()
                
                //sign up
                
            NavigationLink{
                    RegistrationView()
                    .navigationBarBackButtonHidden(true)
                }
            label: {
                HStack(spacing:3) {
                    Text("Don't have an account?")
                    Text("Sign Up")
                        .fontWeight(.bold)
                }
                .font(.system(size:14))
            }
                
                
            }
        }

    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View { LoginView() } }
