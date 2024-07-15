import SwiftUI
import Combine
import FirebaseAuth
import FirebaseFirestore

enum UserType: String {
    case admin
    case librarian
}

class AuthViewModel: ObservableObject {
    @AppStorage("isAuthenticated") var isAuthenticated = false
    @AppStorage("userType") var storedUserType: String?
    
    @Published var email = ""
    @Published var password = ""
    @Published var loginError: String?
    @Published var showAlert = false
    @Published var userType: UserType? {
        didSet {
            storedUserType = userType?.rawValue
        }
    }
    
    func login(email: String, password: String, completion: @escaping (Bool) -> Void) {
        let db = Firestore.firestore()
        let adminRef = db.collection("admin").document("allowedadmin")
        
        adminRef.getDocument { document, error in
            if let document = document, document.exists {
                if let adminData = document.data(),
                   let storedEmail = adminData["email"] as? String,
                   let storedPassword = adminData["password"] as? String {
                    if email == storedEmail && password == storedPassword {
                        DispatchQueue.main.async {
                            self.isAuthenticated = true
                            self.userType = .admin
                        }
                        completion(true)
                        return
                    }
                }
            }
            
            // Check librarian credentials using Firebase Authentication
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let error = error {
                    DispatchQueue.main.async {
                        self.loginError = error.localizedDescription
                        self.showAlert = true
                        completion(false)
                    }
                    return
                }
                
                // Successfully signed in
                DispatchQueue.main.async {
                    self.isAuthenticated = true
                    self.userType = .librarian
                    completion(true)
                }
            }
        }
    }
    
    func logout() {
        do {
            try Auth.auth().signOut()
            self.isAuthenticated = false
            self.userType = nil
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
}
