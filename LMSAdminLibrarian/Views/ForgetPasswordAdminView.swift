//
//  ForgetPasswordAdminView.swift
//  LMS_Admin_Librarian
//
//  Created by Aida Sharon Bruce on 11/07/24.
//

import SwiftUI
import Firebase
import LocalAuthentication

struct ForgetPasswordAdminView: View {
    @State private var email: String = ""
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var resetPasswordSuccess: Bool = false
    
    @State private var isEmailValid = false
    @State private var emailValidationMessage = ""
    
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
                    
                    TextField("Email", text: $email)
                        .padding()
                        .background(Color(UIColor.clear))
                        .cornerRadius(10)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color("ThemeOrange")))
                        .frame(maxWidth: .infinity)
                        .onChange(of: email, initial: false) { oldValue, newValue in
                            (isEmailValid, emailValidationMessage) = validateEmail(newValue)
                        }
                    
                    Text(emailValidationMessage)
                        .font(.caption)
                        .foregroundColor(isEmailValid ? .green : .red)
                    
                    
                    
                    Button(action: {
                        checkIfEmailExists()
                    }) {
                        Spacer()
                        Text("Next")
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
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text(alertTitle),
                        message: Text(alertMessage),
                        dismissButton: .default(Text("OK"))
                    )
                }
                .padding(40)
            }
            .padding(.leading, 50)
            .padding(.trailing, 50)
            .background(Color.background)
        }
    }
    
    func checkIfEmailExists() {
        guard isEmailValid else {
            showAlert(title: "Invalid Email", message: "Please enter a valid email.")
            return
        }
        
        let db = Firestore.firestore()
        db.collection("librarians").whereField("email", isEqualTo: email).getDocuments { (querySnapshot, error) in
            if let error = error {
                self.showAlert(title: "Error", message: "Error checking email: \(error.localizedDescription)")
            } else if querySnapshot?.documents.isEmpty == true {
                self.showAlert(title: "Error", message: "This email is not registered.")
            } else {
                self.sendPasswordResetEmail()
            }
        }
    }
    
    func sendPasswordResetEmail() {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                self.showAlert(title: "Error", message: "Error sending password reset email: \(error.localizedDescription)")
            } else {
                self.showAlert(title: "Success", message: "Password reset email sent successfully. Check your email.")
            }
        }
    }
    
    func showAlert(title: String, message: String) {
        self.alertTitle = title
        self.alertMessage = message
        self.showAlert = true
    }
    
    func validateEmail(_ email: String) -> (Bool, String) {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Z0-9a-z.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        let isValid = emailPred.evaluate(with: email)
        let message = isValid ? "Valid email format." : "Invalid email format."
        return (isValid, message)
    }
}

struct ForgetPasswordAdminView_Previews: PreviewProvider {
    static var previews: some View {
        ForgetPasswordAdminView()
            .previewInterfaceOrientation(.landscapeLeft)
            .previewDevice("iPad Pro (11-inch) (3rd generation)")
    }
}
