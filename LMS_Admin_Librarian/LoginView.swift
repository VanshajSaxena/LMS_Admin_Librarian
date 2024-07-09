import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseAuth

struct LoginView: View {
    @State private var userID: String = ""
    @State private var password: String = ""
    @State private var isRememberMe: Bool = false
    @State private var isShowingForgotPassword: Bool = false
    @State private var loginError: String?
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var navigationPath = NavigationPath()
    
    @State private var isUserIDValid = false
    @State private var userIDValidationMessage = ""
    @State private var isPasswordValid = false
    @State private var passwordValidationMessage = ""

    var body: some View {
        NavigationStack(path: $navigationPath) {
            GeometryReader { geometry in
                ZStack {
                    Color("BackgroundColor")
                        .edgesIgnoringSafeArea(.all)
                    HStack {
                        Image("LoginAdminlibrarian")
                            .resizable()
                            .scaledToFit()
                            .frame(width: geometry.size.width * 0.5)
                            .padding(.top, 250)
                        
                        Spacer()
                        
                        VStack(alignment: .center, spacing: 20) {
                            Text("Welcome Back 👋")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .padding(30)
                            
                            VStack(alignment: .leading) {
                                TextField("User ID", text: $userID)
                                    .padding()
                                    .background(Color(.white))
                                    .cornerRadius(12)
                                    .autocapitalization(.none)
                                    .onChange(of: userID) { newValue in
                                        (isUserIDValid, userIDValidationMessage) = validateUserID(newValue)
                                    }
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(isUserIDValid ? Color.green : Color.red, lineWidth: 1)
                                    )
                                
                                Text(userIDValidationMessage)
                                    .font(.caption)
                                    .foregroundColor(isUserIDValid ? .green : .red)
                            }

                            VStack(alignment: .leading) {
                                SecureField("Password", text: $password)
                                    .padding()
                                    .background(Color(.white))
                                    .cornerRadius(12)
                                    .onChange(of: password) { newValue in
                                        (isPasswordValid, passwordValidationMessage) = validatePassword(newValue)
                                    }
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(isPasswordValid ? Color.green : Color.red, lineWidth: 1)
                                    )
                                
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
                                    Text("Forgot Password?")
                                        .foregroundColor(.blue)
                                }
                            }
                            .padding(.leading)
                            .padding(.trailing)
                            
                            Button(action: login) {
                                Text("Login")
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(width: geometry.size.width * 0.2)
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
        }
    }

    func login() {
        guard isUserIDValid else {
            alertMessage = "Please enter a valid User ID."
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
                    if userID == storedEmail && password == storedPassword {
                        DispatchQueue.main.async {
                            navigateToView(view: "AdminView")
                        }
                        return
                    }
                }
            }

            // Check librarian credentials using Firestore
            let librarianRef = db.collection("librarians").document(userID)
            librarianRef.getDocument { document, error in
                if let document = document, document.exists {
                    if let librarianData = document.data(),
                       let storedPassword = librarianData["password"] as? String {
                        if password == storedPassword {
                            DispatchQueue.main.async {
                                navigateToView(view: "InventoryView")
                            }
                            return
                        }
                    }
                }
                
                alertMessage = "Invalid credentials"
                showAlert = true
            }
        }
    }

    func navigateToView(view: String) {
        navigationPath.append(view)
    }

    func validateUserID(_ userID: String) -> (Bool, String) {
        let isValid = !userID.isEmpty
        let message = isValid ? "User ID is valid." : "User ID cannot be empty."
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
