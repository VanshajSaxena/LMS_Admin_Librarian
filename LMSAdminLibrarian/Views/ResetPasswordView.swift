//
//  ResetPasswordView.swift
//  LMS_Admin_Librarian
//
//  Created by Aida Sharon Bruce on 11/07/24.
//

import SwiftUI
import Firebase
import LocalAuthentication

struct ResetPasswordView: View {
    @State private var password: String = ""
    
    var body: some View {
        GeometryReader { geometry in
            HStack {
                // Spacer()
                VStack {
                    Spacer()
                    Image("ForgotPassword")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 580, height: 600)
                }
    
                .background(Color.clear)
                
                // Forgot Password Form
                VStack(alignment: .center) {
                    Spacer()
                        Text("Forgot Password")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .padding(.bottom, 50)
                    .padding(.top,-40)
                    
                    VStack(alignment: .leading) {
                        SecureField("New password", text: $password)
                            .padding()
                            .background(Color(UIColor.clear))
                            .cornerRadius(10)
                            .keyboardType(.default)
                            .autocapitalization(.none)
                            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color("ThemeOrange")))
                            .frame(maxWidth: .infinity)
                    }
                    .padding(.bottom, 30)
                    
                    VStack(alignment: .leading) {
                        SecureField("Confirm password", text: $password)
                            .padding()
                            .background(Color(UIColor.clear))
                            .cornerRadius(10)
                            .keyboardType(.default)
                            .autocapitalization(.none)
                            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color("ThemeOrange")))
                            .frame(maxWidth: .infinity)
                    }
                        
                    
                    
                    
                    Button(action: {
                       //
                    }) {
                        Spacer()
                        Text("Done")
                            .fontWeight(.bold)
                                                .frame(maxWidth: 220)
                            .padding()
                            .background(Color("ThemeOrange"))
                            .foregroundColor(.white)
                            .cornerRadius(12)
                            .padding(.top, 90)
              Spacer()
                    }
                    
                    Spacer()
                }
                .padding(40)
            }
            .padding(.leading, 50)
            .padding(.trailing, 50)
            .background(Color.background)
        }
    }
    
  
}

struct ResetPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ResetPasswordView()
            .previewInterfaceOrientation(.landscapeLeft)
            .previewDevice("iPad Pro (11-inch) (3rd generation)")
    }
}
