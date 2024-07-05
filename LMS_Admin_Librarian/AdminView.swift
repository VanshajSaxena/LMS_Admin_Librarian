import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseAuth

struct AdminView: View {
    @State private var userID: String = ""
    @State private var librarianEmail: String = ""
    @State private var librarianPassword: String = ""
    @State private var creationError: String?
    @State private var successMessage: String?

    var body: some View {
        VStack {
            TextField("User ID", text: $userID)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(8)
                .autocapitalization(.none)

            TextField("Librarian Gmail", text: $librarianEmail)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(8)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)

            SecureField("Librarian Password", text: $librarianPassword)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(8)
            
            if let creationError = creationError {
                Text(creationError)
                    .foregroundColor(.red)
                    .padding()
            }
            
            if let successMessage = successMessage {
                Text(successMessage)
                    .foregroundColor(.green)
                    .padding()
            }

            Button(action: createLibrarian) {
                Text("Create Librarian")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
            }
            .padding()
        }
        .padding()
        .navigationTitle("Admin Home")
    }

    func createLibrarian() {
        guard !userID.isEmpty else {
            creationError = "Please enter a user ID"
            return
        }

        guard !librarianEmail.isEmpty else {
            creationError = "Please enter an email"
            return
        }
        
        guard !librarianPassword.isEmpty else {
            creationError = "Please enter a password"
            return
        }
        
        guard isValidGmail(email: librarianEmail) else {
            creationError = "Please enter a valid Gmail address"
            return
        }
        
        print("Starting librarian creation process...")
        
        // Authenticate the admin with Firebase Authentication
        Auth.auth().signInAnonymously { (result, error) in
            if let error = error {
                print("Error authenticating admin anonymously: \(error.localizedDescription)")
                creationError = "Error creating librarian: Auth failed"
                return
            }
            
            print("Admin authenticated successfully.")
            
            // Admin authenticated successfully
            guard let user = result?.user else {
                creationError = "Error creating librarian: No user"
                return
            }
            
            // Create librarian user account with email and password
            Auth.auth().createUser(withEmail: librarianEmail, password: librarianPassword) { (authResult, error) in
                if let error = error {
                    print("Error creating librarian user: \(error.localizedDescription)")
                    creationError = "Error creating librarian: \(error.localizedDescription)"
                    return
                }
                
                guard let librarianUID = authResult?.user.uid else {
                    creationError = "Error creating librarian: No UID"
                    return
                }
                
                print("Librarian user created successfully. UID: \(librarianUID)")
                
                // Add librarian credentials to Firestore
                let db = Firestore.firestore()
                let librarianRef = db.collection("librarians").document(librarianUID)
                
                librarianRef.setData([
                    "userID": userID,
                    "email": librarianEmail
                ]) { error in
                    if let error = error {
                        print("Error adding librarian to Firestore: \(error.localizedDescription)")
                        creationError = "Error creating librarian: \(error.localizedDescription)"
                    } else {
                        print("Librarian added to Firestore successfully.")
                        successMessage = "Librarian created successfully"
                        userID = ""
                        librarianEmail = ""
                        librarianPassword = ""
                    }
                }
            }
        }
    }
    
    func isValidGmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@gmail.com"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}

struct AdminView_Previews: PreviewProvider {
    static var previews: some View {
        AdminView()
    }
}
