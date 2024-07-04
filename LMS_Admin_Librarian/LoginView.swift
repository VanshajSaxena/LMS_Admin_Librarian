//
//  LoginView.swift
//  login
//
//  Created by mac on 03/07/24.
//

import Foundation
import SwiftUI

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isRememberMe: Bool = false
    @State private var isShowingForgotPassword: Bool = false
    @State private var isLoginSuccessful: Bool = false

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color("BackgroundColor")
                    .edgesIgnoringSafeArea(.all)
                HStack {
                    VStack(alignment: .center, spacing: 30) {
                        Spacer()
                        Text("Welcome Back 👋")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(30)

                        TextField("Email", text: $email)
                            .padding()
                            .background(Color(.white))
                            .cornerRadius(12)
                            .frame(width: 411)

                        SecureField("Password", text: $password)
                            .padding()
                            .background(Color(.white))
                            .cornerRadius(12)
                            .frame(width: 411)

                        HStack {
                            Button(action: {
                                isRememberMe.toggle()
                            }) {
                                HStack {
                                    Image(systemName: isRememberMe ? "checkmark.square" : "square")
                                    Text("Remember me!")
                                }
                            }
                            Spacer()
                            Button(action: {
                                isShowingForgotPassword.toggle()
                            }) {
                                Text("Forgot Password?")
                                    .foregroundColor(.blue)
                            }
                        }
                        .padding(.leading)
                        .padding(.trailing)

                        Button(action: {
                            // Implement login validation logic here
                            if validateCredentials(email: email, password: password) {
                                isLoginSuccessful = true
                            }
                        }) {
                            Text("Login")
                                .foregroundColor(.white)
                                .padding()
                                .frame(width: 317)
                                .background(Color("ThemeOrange"))
                                .cornerRadius(12)
                                .padding(EdgeInsets(top: 50, leading: 0, bottom: 0, trailing: 0))
                        }
                        .alert(isPresented: $isLoginSuccessful) {
                            Alert(
                                title: Text("Login Successful"),
                                message: Text("Welcome back!"),
                                dismissButton: .default(Text("OK"))
                            )
                        }

                        Spacer()
                    }
                    .padding()
                    .frame(width: geometry.size.width * 0.4)

                    Spacer()

                    // Image view on the right side
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color("ThemeOrange"))
                        .frame(width: geometry.size.width * 0.5, height: geometry.size.height * 0.9)
                        .overlay(
                            Image(systemName: "photo")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: geometry.size.width * 0.5, height: geometry.size.height * 0.9)
                        )
                        .cornerRadius(20)
                    Spacer()
                }
                .padding()
            }
        }
    }

    func validateCredentials(email: String, password: String) -> Bool {
        // Replace with your own logic to validate credentials
        return email == "test@example.com" && password == "password"
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .previewDevice("iPad Pro (11-inch) (3rd generation)")
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
