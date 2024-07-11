import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseAuth

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isRememberMe: Bool = false
    @State private var isShowingForgotPassword: Bool = false
    @State private var loginError: String?
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var navigationPath = NavigationPath()
    
    @State private var isEmailValid = false
    @State private var emailValidationMessage = ""
    @State private var isPasswordValid = false
    @State private var passwordValidationMessage = ""

    var body: some View {
        NavigationStack(path: $navigationPath) {
            GeometryReader { geometry in
                ZStack {
                   
                    HStack {
                        VStack {
                            Spacer()
                            Image("LoginAdminlibrarian")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 700, height: 700)
                                .padding(.leading, 0)
                        }
                        .background(Color.clear)
                        
                        VStack(alignment: .center, spacing: 20) {
                            Text("Welcome Back")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .padding(.bottom, 50)
                            
                            VStack(alignment: .leading) {
                                TextField("Email", text: $email)
                                    .padding()
                                    .padding(.horizontal, 20)
                                    .frame(maxWidth: 600)
                                    .background(Color(.clear))
                                    .cornerRadius(12)
                                    .keyboardType(.emailAddress)
                                    .autocapitalization(.none)
                                    .onChange(of: email) { newValue in
                                        (isEmailValid, emailValidationMessage) = validateEmail(newValue)
                                    }
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color("ThemeOrange")))
                                
                                Text(emailValidationMessage)
                                    .font(.caption)
                                    .foregroundColor(isEmailValid ? .green : .red)
                            }

                            VStack(alignment: .leading) {
                                SecureField("Password", text: $password)
                                    .padding()
                                    .background(Color(.clear))
                                    .cornerRadius(12)
                                    .onChange(of: password) { newValue in
                                        (isPasswordValid, passwordValidationMessage) = validatePassword(newValue)
                                    }
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                           .stroke(Color("ThemeOrange")))
                                
                                Text(passwordValidationMessage)
                                    .font(.caption)
                                    .foregroundColor(isPasswordValid ? .green : .red)
                            }
                            
                            if let loginError = loginError {
                                Text(loginError)
                                    .foregroundColor(.red)
                                    .padding()
                            }
                            
                            HStack {
                                Button(action: {
                                    isRememberMe.toggle()
                                }) {
                                    // Remember Me button (optional implementation)
                                }
                                Spacer()
                                Button(action: {
                                    isShowingForgotPassword.toggle()
                                }) {
                                    NavigationLink(destination: ForgetPasswordView()) {
                                        Text("Forgot Password?")
                                            .foregroundColor(.accentColor)
                                    }
                                }
                            }
                            .padding(.leading)
                            .padding(.trailing)
                            
                            Button(action: login) {
                                Text("Login")
                                    .foregroundColor(.white)
                                    .frame(maxWidth: 220)
                                    .padding()
                                    .background(Color("ThemeOrange"))
                                    .cornerRadius(12)
                                    .padding(.top, 50)
                            }
                            .padding()
                        }
                        .frame(width: geometry.size.width * 0.4)
                        
                        Spacer()
                    }
                    .padding()
                }
                .navigationDestination(for: String.self) { destination in
                    if destination == "AdminView" {
                        AddLibrarianView()
                    } else if destination == "InventoryView" {
                        InventoryView()
                    }
                }
                .sheet(isPresented: $isShowingForgotPassword) {
                    ForgetPasswordView()
                }
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Login Error"),
                        message: Text(alertMessage),
                        dismissButton: .default(Text("OK"))
                    )
                }
            }
            .padding(.leading, -50)
            .padding(.trailing, 200)
            .padding(.bottom, -50)
          
        }
    }

    func login() {
        guard isEmailValid else {
            alertMessage = "Please enter a valid email."
            showAlert = true
            return
        }
        
        guard isPasswordValid else {
            alertMessage = "Please enter your password."
            showAlert = true
            return
        }

        let db = Firestore.firestore()
        let adminRef = db.collection("admin").document("allowedadmin")
        adminRef.getDocument { document, error in
            if let document = document, document.exists {
                if let adminData = document.data(),
                   let storedEmail = adminData["email"] as? String,
                   let storedPassword = adminData["password"] as? String {
                    if email == storedEmail && password == storedPassword {
                        DispatchQueue.main.async {
                            navigateToView(view: "AdminView")
                        }
                        return
                    }
                }
            }

            // Check librarian credentials using Firebase Authentication
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let error = error {
                    print("Error signing in: \(error.localizedDescription)")
                    alertMessage = "Invalid credentials"
                    showAlert = true
                    return
                }
                
                // Successfully signed in
                DispatchQueue.main.async {
                    navigateToView(view: "InventoryView")
                }
            }
        }
    }

    func navigateToView(view: String) {
        navigationPath.append(view)
    }

    func validateEmail(_ email: String) -> (Bool, String) {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Z0-9a-z.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let isValid = emailPred.evaluate(with: email)
        let message = isValid ? "Valid email format." : "Invalid email format."
        return (isValid, message)
    }

    func validatePassword(_ password: String) -> (Bool, String) {
        let isValid = !password.isEmpty
        let message = isValid ? "Password is valid." : "Password cannot be empty."
        return (isValid, message)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .previewDevice("iPad Pro (11-inch) (3rd generation)")
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
