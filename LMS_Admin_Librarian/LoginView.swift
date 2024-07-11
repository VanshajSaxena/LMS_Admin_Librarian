import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseAuth



struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isShowingForgotPassword: Bool = false
    @State private var navigationPath = NavigationPath()
    
    @State private var isEmailValid = false
    @State private var emailValidationMessage = ""
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
                                TextField("Email", text: $email)
                                    .padding()
                                    .background(Color(.white))
                                    .cornerRadius(12)
                                    .keyboardType(.emailAddress)
                                    .autocapitalization(.none)
                                    .onChange(of: email) { oldValue, newValue in
                                        (isEmailValid, emailValidationMessage) = validateEmail(newValue)
                                    }
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(isEmailValid ? Color.green : Color.red, lineWidth: 1)
                                    )
                                
                                Text(emailValidationMessage)
                                    .font(.caption)
                                    .foregroundColor(isEmailValid ? .green : .red)
                            }

                            VStack(alignment: .leading) {
                                SecureField("Password", text: $password)
                                    .padding()
                                    .background(Color(.white))
                                    .cornerRadius(12)
                                    .onChange(of: password) { oldValue, newValue in
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
                            
                            if authViewModel.showAlert {
                                Text(authViewModel.loginError ?? "Unknown error")
                                    .foregroundColor(.red)
                                    .padding()
                            }
                            
                            HStack {
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
                                login()
                            }) {
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
                .alert(isPresented: $authViewModel.showAlert) {
                    Alert(
                        title: Text("Login Error"),
                        message: Text(authViewModel.loginError ?? "Unknown error"),
                        dismissButton: .default(Text("OK"))
                    )
                }
            }
        }
    }

    func login() {
        guard isEmailValid else {
            authViewModel.loginError = "Please enter a valid email."
            authViewModel.showAlert = true
            return
        }
        
        guard isPasswordValid else {
            authViewModel.loginError = "Please enter your password."
            authViewModel.showAlert = true
            return
        }

        authViewModel.login(email: email, password: password) { success in
            if !success {
                authViewModel.loginError = "Invalid credentials"
                authViewModel.showAlert = true
            }
        }
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
            .environmentObject(AuthViewModel())
    }
}
