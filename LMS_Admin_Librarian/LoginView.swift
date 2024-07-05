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
                .navigationDestination(for: String.self) { destination in
                    if destination == "AdminView" {
                        AdminView()
                    } else if destination == "LibrarianView" {
                        LibrarianView()
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

                DispatchQueue.main.async {
                    navigateToView(view: "LibrarianView")
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
