import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseAuth

struct AdminView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @State private var name: String = ""
    @State private var age: String = ""
    @State private var yearsOfExperience: String = ""
    @State private var userID: String = ""
    @State private var librarianEmail: String = ""
    @State private var librarianPassword: String = ""
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    @State private var isEmailValid = false
    @State private var emailValidationMessage = ""
    @State private var isPasswordValid = false
    @State private var passwordValidationMessage = ""
    @State private var isUserIDValid = false
    @State private var userIDValidationMessage = ""
    @State private var isNameValid = false
    @State private var nameValidationMessage = ""
    
    var onAdd: (String, String, String, String, String) -> Void
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                ScrollView {
                    Spacer()
                    VStack(alignment: .leading, spacing: 15) {
                        Spacer()
                        Text("Add Staff")
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(.horizontal, geometry.size.width * 0.15)
                            .foregroundColor(.black)
                        
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Name")
                                .foregroundColor(.orange)
                            TextField(" ", text: $name)
                                .padding()
                                .frame(height: 50)
                                .background(Color.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray, lineWidth: 1)
                                )
                                .multilineTextAlignment(.leading)
                                .onChange(of: name) { newValue in
                                    validateName(newValue)
                                }
                            
                            Text(nameValidationMessage)
                                .font(.caption)
                                .foregroundColor(isNameValid ? .green : .red)
                            
                            Text("Age")
                                .foregroundColor(.orange)
                            TextField("", text: $age)
                                .padding()
                                .frame(height: 50)
                                .background(Color.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray, lineWidth: 1)
                                )
                                .multilineTextAlignment(.leading)
                            
                            VStack(alignment: .leading) {
                                Text("Email")
                                    .foregroundColor(.orange)
                                TextField("", text: $librarianEmail)
                                    .padding()
                                    .frame(height: 50)
                                    .background(Color.white)
                                    .keyboardType(.emailAddress)
                                    .autocapitalization(.none)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.gray, lineWidth: 1)
                                    )
                                    .multilineTextAlignment(.leading)
                                    .onChange(of: librarianEmail) { newValue in
                                        validateEmail(newValue)
                                    }
                                
                                Text(emailValidationMessage)
                                    .font(.caption)
                                    .foregroundColor(isEmailValid ? .green : .red)
                            }
                            
                            Text("Years of Experience")
                                .foregroundColor(.orange)
                            TextField("", text: $yearsOfExperience)
                                .padding()
                                .frame(height: 50)
                                .background(Color.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray, lineWidth: 1)
                                )
                                .multilineTextAlignment(.leading)
                        }
                        .frame(width: geometry.size.width * 0.68)
                        .padding(.horizontal, geometry.size.width * 0.15)
                        
                        Spacer()
                        
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Generate Credentials")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                            
                            Text("User ID")
                                .foregroundColor(.orange)
                            TextField("Enter the librarian ID", text: $userID)
                                .padding()
                                .frame(height: 50)
                                .autocapitalization(.none)
                                .background(Color.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray, lineWidth: 1)
                                )
                                .multilineTextAlignment(.leading)
                                .onChange(of: userID) { newValue in
                                    validateUserID(newValue)
                                }
                            
                            Text(userIDValidationMessage)
                                .font(.caption)
                                .foregroundColor(isUserIDValid ? .green : .red)
                            
                            VStack(alignment: .leading) {
                                Text("Password")
                                    .foregroundColor(.orange)
                                SecureField("Enter the Password", text: $librarianPassword)
                                    .padding()
                                    .frame(height: 50)
                                    .background(Color.white)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.gray, lineWidth: 1)
                                    )
                                    .multilineTextAlignment(.leading)
                                    .onChange(of: librarianPassword) { newValue in
                                        (isPasswordValid, passwordValidationMessage) = validatePassword(newValue)
                                    }
                                
                                Text(passwordValidationMessage)
                                    .font(.caption)
                                    .foregroundColor(isPasswordValid ? .green : .red)
                            }
                        }
                        .frame(width: geometry.size.width * 0.68)
                        .padding(.horizontal, geometry.size.width * 0.15)
                        
                        HStack {
                            Spacer()
                            Button(action: createLibrarian) {
                                Text("Done")
                                    .foregroundColor(.white)
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 30)
                                    .background(Color.orange)
                                    .cornerRadius(8)
                            }
                            .frame(width: 150, height: 40)
                            Spacer()
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(16)
                    .shadow(radius: 5)
                    .padding()
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
            }
            .background(Color.gray.opacity(0.2).edgesIgnoringSafeArea(.all))
            .frame(width: geometry.size.width, height: geometry.size.height)
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text(alertTitle),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
    
    func createLibrarian() {
        guard isNameValid else {
            showAlert(title: "Error", message: "Please enter a valid name with different first and last names.")
            return
        }

        guard !userID.isEmpty else {
            showAlert(title: "Error", message: "Please enter a user ID")
            return
        }
        
        guard !librarianEmail.isEmpty else {
            showAlert(title: "Error", message: "Please enter an email")
            return
        }
        
        guard !librarianPassword.isEmpty else {
            showAlert(title: "Error", message: "Please enter a password")
            return
        }
        
        guard isEmailValid else {
            showAlert(title: "Error", message: "Please enter a valid Gmail address")
            return
        }
        
        guard isPasswordValid else {
            showAlert(title: "Error", message: "Password must be at least 8 characters, including one uppercase, one lowercase, one number, and one special character")
            return
        }
        
        guard isUserIDValid else {
            showAlert(title: "Error", message: "User ID already exists. Please choose another one.")
            return
        }
        
        print("Starting librarian creation process...")
        
        // Proceed with creating the librarian
        Auth.auth().signInAnonymously { (result, error) in
            if let error = error {
                showAlert(title: "Error", message: "Error authenticating admin anonymously: \(error.localizedDescription)")
                return
            }
            
            print("Admin authenticated successfully.")
            
            guard let user = result?.user else {
                showAlert(title: "Error", message: "Error creating librarian: No user")
                return
            }
            
            Auth.auth().createUser(withEmail: librarianEmail, password: librarianPassword) { (authResult, error) in
                if let error = error {
                    showAlert(title: "Error", message: "Error creating librarian: \(error.localizedDescription)")
                    return
                }
                
                guard let librarianUID = authResult?.user.uid else {
                    showAlert(title: "Error", message: "Error creating librarian: No UID")
                    return
                }
                
                print("Librarian user created successfully. UID: \(librarianUID)")
                
                let db = Firestore.firestore()
                let librarianRef = db.collection("librarians").document(librarianUID)
                
                librarianRef.setData([
                    "userID": userID,
                    "email": librarianEmail
                ]) { error in
                    if let error = error {
                        showAlert(title: "Error", message: "Error adding librarian to Firestore: \(error.localizedDescription)")
                    } else {
                        showAlert(title: "Success", message: "Librarian created successfully")
                        DispatchQueue.main.async {
                            onAdd(name, age, yearsOfExperience, userID, librarianEmail)
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
            }
        }
    }
    
    func showAlert(title: String, message: String) {
        alertTitle = title
        alertMessage = message
        showAlert = true
    }
    
    func validateEmail(_ email: String) {
        if !isValidGmail(email: email) {
            self.emailValidationMessage = "Invalid Gmail address."
            self.isEmailValid = false
            return
        }
        
        let db = Firestore.firestore()
        let emailRef = db.collection("librarians").whereField("email", isEqualTo: email)
        emailRef.getDocuments { (querySnapshot, error) in
            if let error = error {
                self.emailValidationMessage = "Error checking email: \(error.localizedDescription)"
                self.isEmailValid = false
            } else if let documents = querySnapshot?.documents, !documents.isEmpty {
                self.emailValidationMessage = "Email already exists."
                self.isEmailValid = false
            } else {
                self.emailValidationMessage = "Valid Gmail address."
                self.isEmailValid = true
            }
        }
    }
    
    func validateUserID(_ userID: String) {
        let db = Firestore.firestore()
        let userRef = db.collection("librarians").whereField("userID", isEqualTo: userID)
        userRef.getDocuments { (querySnapshot, error) in
            if let error = error {
                self.userIDValidationMessage = "Error checking user ID: \(error.localizedDescription)"
                self.isUserIDValid = false
            } else if let documents = querySnapshot?.documents, !documents.isEmpty {
                self.userIDValidationMessage = "User ID already exists."
                self.isUserIDValid = false
            } else {
                self.userIDValidationMessage = "User ID is available."
                self.isUserIDValid = true
            }
        }
    }
    
    func validateName(_ name: String) {
        let parts = name.split(separator: " ")
        if parts.count < 2 {
            self.nameValidationMessage = "Please enter both first and last names."
            self.isNameValid = false
        } else if parts[0].lowercased() == parts[1].lowercased() {
            self.nameValidationMessage = "First and last names should be different."
            self.isNameValid = false
        } else {
            self.nameValidationMessage = "Valid name."
            self.isNameValid = true
        }
    }
    
    func isValidGmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@gmail.com"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func validatePassword(_ password: String) -> (Bool, String) {
        let passwordRegEx = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&#])[A-Za-z\\d@$!%*?&#]{8,}$"
        let passwordPred = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
        let isValid = passwordPred.evaluate(with: password)
        let message = isValid ? "Valid password." : "Password must be at least 8 characters, including one uppercase, one lowercase, one number, and one special character."
        return (isValid, message)
    }
}

struct AdminView_Previews: PreviewProvider {
    static var previews: some View {
        AdminView { _, _, _, _, _ in }
    }
}
