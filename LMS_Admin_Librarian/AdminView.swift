import SwiftUI
import FirebaseFirestore

struct AdminView: View {
    @State private var librarianEmail: String = ""
    @State private var librarianPassword: String = ""
    @State private var creationError: String?
    @State private var successMessage: String?

    var body: some View {
        VStack {
            TextField("Librarian Email", text: $librarianEmail)
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
        let db = Firestore.firestore()
        let adminRef = db.collection("librarians")
        
        // Check if the email is not empty
        guard !librarianEmail.isEmpty else {
            creationError = "Please enter an email"
            return
        }
        
        // Check if the password is not empty
        guard !librarianPassword.isEmpty else {
            creationError = "Please enter a password"
            return
        }
        
        // Add the librarian credentials to Firestore with auto-generated document ID
        adminRef.addDocument(data: [
            "email": librarianEmail,
            "password": librarianPassword
        ]) { error in
            if let error = error {
                print("Error creating librarian: \(error.localizedDescription)")
                creationError = "Error creating librarian"
            } else {
                successMessage = "Librarian created successfully"
                librarianEmail = ""
                librarianPassword = ""
            }
        }
    }
}


