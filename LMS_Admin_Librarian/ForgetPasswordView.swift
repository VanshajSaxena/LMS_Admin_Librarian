import SwiftUI
import Firebase
import LocalAuthentication


struct ForgetPasswordView: View {
    @State private var email: String = ""
    @State private var error: String?
    @State private var resetPasswordSuccess: Bool = false

    var body: some View {
        VStack {
            Text("Forgot Password")
                .font(.title)
                .fontWeight(.bold)
                .padding()
            
            TextField("Email", text: $email)
                .padding()
                .background(Color(.white))
                .cornerRadius(12)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
            
            if let error = error {
                Text(error)
                    .foregroundColor(.red)
                    .padding()
            }
            
            if resetPasswordSuccess {
                Text("Password reset email sent successfully. Check your email.")
                    .foregroundColor(.green)
                    .padding()
            }
            
            Button(action: {
                authenticateWithFaceID()
                sendPasswordResetEmail()
            }) {
                Text("Change Password")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color("ThemeOrange"))
                    .cornerRadius(12)
                    .padding(.top, 50)
            }
            .padding()
            
            
        }
    }
    
    func authenticateWithFaceID() {
        // Implementation remains the same as before
        // You can keep the existing implementation
    }
    
    func sendPasswordResetEmail() {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                self.error = "Error sending password reset email: \(error.localizedDescription)"
            } else {
                self.resetPasswordSuccess = true
                self.error = nil
            }
        }
    }
}

struct ForgetPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ForgetPasswordView()
    }
}
