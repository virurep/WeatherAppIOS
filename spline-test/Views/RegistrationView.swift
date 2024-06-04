//
//  spline-test
//
//  Created by Gagan Singh on 6/3/24.
//

import Foundation
import SwiftUI

struct RegistrationView: View {
  @State private var email = ""
  @State private var fullName = ""
  @State private var password = ""
  @State private var confirmPassword = ""
  @Environment(\.dismiss) var dismiss

  var body: some View {
    VStack(alignment: .center) { // Change alignment to leading

      Image("chicken no background")
        .resizable()
        .scaledToFill()
        .frame(width: 120, height: 150)
        .padding(.top, 30)

      VStack(spacing: 16) {
        InputView(text: $email,
                  title: "Email Address",
                  placeholder: "name@example.com")
          .autocapitalization(.none)

        InputView(text: $fullName,
                  title: "Full Name",
                  placeholder: "Enter your Name")

        InputView(text: $password,
                  title: "Password",
                  placeholder: "Enter your password",
                  isSecureField: true)
          .autocapitalization(.none)

        InputView(text: $confirmPassword,
                  title: "Confirm Password",
                  placeholder: "Re-enter your password",
                  isSecureField: true)
          .autocapitalization(.none)

        Divider()
      }
      .padding(.horizontal)

      // Sign Up Button
      Button {
        print("Sign user up...")
      } label: {
        Text("Sign Up")
          .fontWeight(.semibold)
          .foregroundColor(.white)
          .padding(.vertical, 12)
          .frame(maxWidth: .infinity)
          .background(Color.blue)
          .cornerRadius(10)
      }
      .padding(.top, 24)

      // Already have an account? section
        HStack(spacing: 4) { // Use HStack for horizontal layout
              Text("Already have an account?")
                .font(.system(size: 14))
                .foregroundColor(.gray)

              Button {
                dismiss()
              } label: {
                Text("Sign In")
                  .fontWeight(.bold)
                  .font(.system(size: 14))
                  .foregroundColor(.blue) // Use same blue as Sign Up button
              }
            }
            .padding(.top, 12) 

            Spacer()

          }
          .padding(.horizontal, 24)
        }
      }

      struct RegistrationView_Previews: PreviewProvider {
        static var previews: some View {
          RegistrationView()
        }
      }
