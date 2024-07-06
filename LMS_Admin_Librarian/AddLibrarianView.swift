import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseAuth

struct AddLibrarianView: View {
   
    @Environment(\.presentationMode) var presentationMode
    @State private var name: String = ""
    @State private var age: String = ""
    @State private var yearsOfExperience: String = ""
    @State private var userID: String = ""
    @State private var librarianEmail: String = ""
    @State private var librarianPassword: String = ""
    @State private var creationError: String?
    @State private var successMessage: String?
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
                            }
                            .frame(width: geometry.size.width * 0.68)
                            .padding(.horizontal, geometry.size.width * 0.15)// Reduce the width of the text fields
                            
                            Spacer()
                            
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Generate Credentials")
                                    .font(.title)
                                    .fontWeight(.bold)
                                   
                                
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
                            }
                            .frame(width: geometry.size.width * 0.68) // Reduce the width of the text fields
                            .padding(.horizontal, geometry.size.width * 0.15)
                            
                            HStack {
                                                      Spacer()
                                Button(action : createLibrarian) {
                                                          
                                                          Text("Done")
                                                              .foregroundColor(.white)
                                                              .padding(.vertical, 10) // Smaller vertical padding
                                                              .padding(.horizontal, 30) // Smaller horizontal padding
                                                              .background(Color.orange)
                                                              .cornerRadius(8)
                                                      }
                                                      .frame(width: 150, height: 40) // Fixed size for the button
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
                                      .frame(width: geometry.size.width, height: geometry.size.height) // Ensure VStack takes full space
                                  }
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
                        userID = userID
                        librarianEmail = librarianEmail
                        librarianPassword = librarianPassword
                        
                        DispatchQueue.main.async {
                            onAdd(name, age, yearsOfExperience, userID, librarianEmail)
                                                presentationMode.wrappedValue.dismiss()
                                            }
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


    
                          

                         
