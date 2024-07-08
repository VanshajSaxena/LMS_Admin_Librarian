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
    @State private var navigationPath = NavigationPath()

    var body: some View {
        NavigationStack(path: $navigationPath) {
            GeometryReader { geometry in
                ZStack {
                    Color("BackgroundColor")
                        .edgesIgnoringSafeArea(.all)
                    HStack {
//                        Spacer()
                        
                        Image("LoginAdminlibrarian")
                            .resizable()
                            .scaledToFit()
                            .frame(width: geometry.size.width * 0.4)
                        
                        Spacer()
                        
                        VStack(alignment: .center, spacing: 30) {
                            Text("Welcome Back 👋")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .padding(30)
                            
                            TextField("Email", text: $email)
                                .padding()
                                .background(Color(.white))
                                .cornerRadius(12)
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                            
                            SecureField("Password", text: $password)
                                .padding()
                                .background(Color(.white))
                                .cornerRadius(12)
                            
                            if let loginError = loginError {
                                Text(loginError)
                                    .foregroundColor(.red)
                                    .padding()
                            }
                            
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
                            
                            Button(action: login) {
                                Text("Login")
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(width: geometry.size.width * 0.4)
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
                    } else if destination == "AddBookView" {
                        AddBookView()
                    }
                }
                .sheet(isPresented: $isShowingForgotPassword) {
                    ForgetPasswordView()
                }
            }
        }
    }

    func login() {
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
                    loginError = "Invalid credentials"
                    return
                }
                
                // Successfully signed in
                DispatchQueue.main.async {
                    navigateToView(view: "AddBookView")
                }
            }
        }
    }

    
    func navigateToView(view: String) {
        navigationPath.append(view)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .previewDevice("iPad Pro (11-inch) (3rd generation)")
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
