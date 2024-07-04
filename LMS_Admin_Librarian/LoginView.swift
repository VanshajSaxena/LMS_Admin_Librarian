import SwiftUI
import Firebase
import FirebaseFirestore

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isRememberMe: Bool = false
    @State private var isShowingForgotPassword: Bool = false
    @State private var loginError: String?
    @State private var isAdmin: Bool = false
    @State private var isLibrarian: Bool = false

    var body: some View {
        NavigationView {
            ZStack {
                Color("BackgroundColor")
                    .edgesIgnoringSafeArea(.all)
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
                            .frame(width: 317)
                            .background(Color("ThemeOrange"))
                            .cornerRadius(12)
                            .padding(.top, 50)
                    }
                    .padding()
                    
                    NavigationLink(destination: AdminView(), isActive: $isAdmin) {
                        EmptyView()
                    }
                    
                    NavigationLink(destination: LibrarianView(), isActive: $isLibrarian) {
                        EmptyView()
                    }
                }
                .padding()
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
                        isAdmin = true
                        return
                    }
                }
            }

            let librarianRef = db.collection("librarians").whereField("email", isEqualTo: email).whereField("password", isEqualTo: password)
            librarianRef.getDocuments { querySnapshot, error in
                if let error = error {
                    print("Error fetching librarian documents: \(error.localizedDescription)")
                    loginError = "Error fetching data"
                    return
                }

                guard let documents = querySnapshot?.documents, !documents.isEmpty else {
                    loginError = "Invalid credentials"
                    return
                }

                isLibrarian = true
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .previewDevice("iPad Pro (11-inch) (3rd generation)")
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
