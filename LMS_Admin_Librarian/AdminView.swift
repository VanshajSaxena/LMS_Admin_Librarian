import SwiftUI
import Firebase
import FirebaseFirestore

struct Librarian: Identifiable, Codable {
    @DocumentID var id: String?
    var name: String
    var email: String
    var age: String
    var yearsOfExperience: String
    var userID : String
    
}

struct AdminView: View {
    @State private var librarians: [Librarian] = []
    @State private var isShowingAddLibrarian = false
    
    var body: some View {
        VStack {
            Text("Librarians")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
            
            List {
                           ForEach(librarians) { librarian in
                               LibrarianRow(librarian: librarian) {
                                   deleteLibrarian(librarian)
                               }
                           }
                       }
                       
            
            Button(action: {
                isShowingAddLibrarian.toggle()
            }) {
                Text("Add Librarian")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.orange)
                    .cornerRadius(12)
            }
            .padding()
            .sheet(isPresented: $isShowingAddLibrarian) {
                AddLibrarianView(onAdd: { name, age, yearsOfExperience, userID, librarianEmail in
                    // Add new librarian to Firestore
                    let db = Firestore.firestore()
                    db.collection("librarians").addDocument(data: [
                        "name": name,
                        "email": librarianEmail,
                        "age": age,
                        "yearsOfExperience": yearsOfExperience,
                        "userID": userID
                    ]) { error in
                        if let error = error {
                            print("Error adding librarian: \(error.localizedDescription)")
                        } else {
                            print("Librarian added successfully.")
                            fetchLibrarians()
                        }
                    }
                })
            }
        }
        .onAppear(perform: fetchLibrarians)
        .navigationTitle("Librarians")
    }
    
    func fetchLibrarians() {
        let db = Firestore.firestore()
        db.collection("librarians").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching librarians: \(error.localizedDescription)")
                return
            }
            
            if let snapshot = snapshot {
                librarians = snapshot.documents.compactMap { document in
                    try? document.data(as: Librarian.self)
                }
            }
        }
    }
    
    func deleteLibrarian(at offsets: IndexSet) {
            let db = Firestore.firestore()
            offsets.forEach { index in
                let librarian = librarians[index]
                if let librarianID = librarian.id {
                    db.collection("librarians").document(librarianID).delete { error in
                        if let error = error {
                            print("Error deleting librarian: \(error.localizedDescription)")
                        } else {
                            print("Librarian deleted successfully.")
                            librarians.remove(at: index)
                        }
                    }
                }
            }
        }
        
        func deleteLibrarian(_ librarian: Librarian) {
            let db = Firestore.firestore()
            if let librarianID = librarian.id {
                db.collection("librarians").document(librarianID).delete { error in
                    if let error = error {
                        print("Error deleting librarian: \(error.localizedDescription)")
                    } else {
                        print("Librarian deleted successfully.")
                        librarians.removeAll(where: { $0.id == librarianID })
                    }
                }
            }
        }
}

struct LibrarianRow: View {
    var librarian: Librarian
    var onDelete: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Name:")
                Text("Email:")
                Text("Age:")
                Text("Years of Experience:")
            }
            .foregroundColor(.gray)
            
            VStack(alignment: .leading) {
                Text(librarian.name)
                Text(librarian.email)
                Text(librarian.age)
                Text(librarian.yearsOfExperience)
            }
            .padding(.leading, 8)
            
            Spacer()
            
            Button(action: {
                onDelete()
            }) {
                Image(systemName: "trash")
                    .foregroundColor(.red)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(8)
        .shadow(radius: 5)
        .padding(.horizontal)
        .padding(.vertical, 4)
    }
}
