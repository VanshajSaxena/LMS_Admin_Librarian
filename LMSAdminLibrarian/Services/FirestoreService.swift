//
//  FirestoreService.swift
//  LMSAdminLibrarian
//
//  Created by Vanshaj on 12/07/24.
//

import FirebaseFirestore

final class FirestoreService {
    private var db = Firestore.firestore()
    
    func getBookDetails(isbn: String) async throws -> FirestoreMetadata {
        let docRef =  db.collection("books").document(isbn)
        let document = try await docRef.getDocument()
        guard let data = document.data() else {
            throw NSError(domain: "Document not found", code: -1, userInfo: nil)
        }
        let totalNumberOfCopies = data["totalNumberOfCopies"] as? Int ?? 0
        let numberOfIssuedCopies =  data["numberOfIssuedCopies"] as? Int ?? 0
        let bookShelf = data["bookColumn"] as? String ?? "A"
        let bookColumn = data["bookShelf"] as? String ?? "1"
        return FirestoreMetadata(isbn: isbn, totalNumberOfCopies: totalNumberOfCopies, numberOfIssuedCopies: numberOfIssuedCopies, bookColumn: bookColumn, bookShelf: bookShelf)
    }
}
