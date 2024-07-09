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
                        .padding(.horizontal, geometry.size.width * 0.15) // Reduce the width of the text fields
                        
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
                        }
                        .frame(width: geometry.size.width * 0.68) // Reduce the width of the text fields
                        .padding(.horizontal, geometry.size.width * 0.15)
                        
                        HStack {
                            Spacer()
                            Button(action: createLibrarian) {
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
        
        guard isValidGmail(email: librarianEmail) else {
            showAlert(title: "Error", message: "Please enter a valid Gmail address")
            return
        }
        
        guard isValidPassword(password: librarianPassword) else {
            showAlert(title: "Error", message: "Password must be at least 8 characters, including one uppercase, one lowercase, one number, and one special character")
            return
        }
        
        print("Starting librarian creation process...")
        
        // Check if userID is unique
        let db = Firestore.firestore()
        let userRef = db.collection("librarians").whereField("userID", isEqualTo: userID)
        userRef.getDocuments { (querySnapshot, error) in
            if let error = error {
                showAlert(title: "Error", message: "Error checking userID uniqueness: \(error.localizedDescription)")
                return
            }
            
            if let documents = querySnapshot?.documents, !documents.isEmpty {
                showAlert(title: "Error", message: "User ID already exists. Please choose another one.")
                return
            }
            
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
    }
    
    func showAlert(title: String, message: String) {
        alertTitle = title
        alertMessage = message
        showAlert = true
    }
    
    func isValidGmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@gmail.com"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func isValidPassword(password: String) -> Bool {
        let passwordRegEx = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&#])[A-Za-z\\d@$!%*?&#]{8,}$"
        let passwordPred = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
        return passwordPred.evaluate(with: password)
    }
}
