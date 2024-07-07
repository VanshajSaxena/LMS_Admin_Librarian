import SwiftUI
import Firebase
import FirebaseFirestore

struct Librarian: Identifiable, Codable {
    @DocumentID var id: String?
    var name: String
    var email: String
    var age: String
    var yearsOfExperience: String
    var userID: String
}

struct AddLibrarianView: View {
    @State private var librarians: [Librarian] = []
    @State private var isShowingAddLibrarian = false
    @State private var searchQuery: String = ""

    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 40) {
                HStack {
                    Text("Staff")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.leading, 50)
                    Spacer()
                    Button(action: {
                        // My Account action
                    }) {
                        HStack {
                            Image(systemName: "person.circle")
                            Text("My Account")
                        }
                        .padding()
                        .background(Color("ThemeOrange"))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                    .padding(.trailing, 50)
                }
                .padding(.top, 50)

                HStack(spacing: 10) {
                    ZStack {
                        TextField("Search the staff", text: $searchQuery)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(8)
                            .frame(height: 40)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color("ThemeOrange"), lineWidth: 2)
                            )
                        HStack {
                            Spacer()
                            Button(action: {
                                searchLibrariansByName()
                            }) {
                                Text("Find")
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 30)
                                    .padding(.vertical, 5)
                                    .background(Color("ThemeOrange"))
                                    .cornerRadius(8)
                            }
                            .padding(.trailing, 5)
                        }
                    }
                    .frame(maxWidth: geometry.size.width * 0.5)
                    .padding(.leading, geometry.size.width * 0.05)
                    Spacer()
                    Button(action: {
                        // Filter action
                    }) {
                        HStack {
                            Image(systemName: "line.horizontal.3.decrease.circle")
                            Text("Filter")
                        }
                        .padding()
                        .foregroundColor(Color("ThemeOrange"))
                        .cornerRadius(8)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color("ThemeOrange")))
                    }
                    .padding(.trailing, 10)
                    Rectangle().frame(width: 1, height: 65).foregroundColor(Color("ThemeOrange"))
                    Button(action: {
                        isShowingAddLibrarian.toggle()
                    }) {
                        HStack {
                            Image(systemName: "plus.square")
                            Text("Add Staff")
                        }
                        .padding()
                        .background(Color("ThemeOrange"))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .sheet(isPresented: $isShowingAddLibrarian) {
                            AdminView(onAdd: { name, age, yearsOfExperience, userID, librarianEmail in
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
                    .padding(.trailing, geometry.size.width * 0.05).padding(.leading, 7)
                }
                .onAppear(perform: fetchLibrarians)
                .navigationTitle("Librarians")

                HStack(spacing: 130) {
                    Text("Name")
                        .font(.headline)
                        .foregroundColor(Color("ThemeOrange"))
                    Text("Age")
                        .font(.headline)
                        .foregroundColor(Color("ThemeOrange"))
                    Text("Email")
                        .font(.headline)
                        .foregroundColor(Color("ThemeOrange"))
                    Text("Years Of Experience")
                        .font(.headline)
                        .foregroundColor(Color("ThemeOrange"))
                    Text("UserID")
                        .font(.headline)
                        .foregroundColor(Color("ThemeOrange"))
                }
                .padding(.horizontal, geometry.size.width * 0.05)
                .padding(.top, 40)

                List {
                    ForEach(librarians) { librarian in
                        LibrarianRow(librarian: librarian) {
                            deleteLibrarian(librarian)
                        }
                    }
                }
                .padding(.horizontal, 15)
                

                

                HStack {
                    Text("This is the End Folks!")
                        .font(.system(size: 40))
                        .fontWeight(.bold)
                        .foregroundColor(Color("ThemeOrange"))
                    Spacer()
                }
                .padding(35)
            }
            .background(Color("BackgroundColor").edgesIgnoringSafeArea(.all))
        }
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

    func searchLibrariansByName() {
        let db = Firestore.firestore()
        db.collection("librarians")
            .whereField("name", isGreaterThanOrEqualTo: searchQuery)
            .whereField("name", isLessThanOrEqualTo: searchQuery + "\u{f8ff}")
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error searching librarians: \(error.localizedDescription)")
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
        HStack(spacing: 130) {
            Text(librarian.name)
                .frame(alignment: .leading)
               
            Text(librarian.age)
                
            Text(librarian.email)
                .frame(alignment: .leading)
                .lineSpacing(100)
                
            Text(librarian.yearsOfExperience)
                .frame(alignment: .leading)
              
            Text(librarian.userID)
               
            Button(action: {
                onDelete()
            }) {
                Image(systemName: "trash")
                    .foregroundColor(.red)
            }
            .padding(.horizontal, 1)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(8)
        
        .padding(.horizontal , 2)
        .padding(.vertical, 4)
    }
}
