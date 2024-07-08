import SwiftUI
import Firebase
import LocalAuthentication

struct ForgetPasswordView: View {
    @State private var email: String = ""
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var resetPasswordSuccess: Bool = false

    var body: some View {
        VStack {
            Text("Forgot Password")
                .font(.title)
                .fontWeight(.bold)
                .padding()
            
            TextField("Email", text: $email)
                .padding(10)
                
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color("ThemeOrange")))
                .frame(width: 480,height: 280)
               
               
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
            
            Button(action: {
                checkIfEmailExists()
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
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text(alertTitle),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    func checkIfEmailExists() {
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
}

struct ForgetPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ForgetPasswordView()
    }
}
