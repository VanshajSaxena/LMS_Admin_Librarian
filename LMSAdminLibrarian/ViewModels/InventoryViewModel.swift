//
//  InventoryViewModel.swift
//  LMS_Admin_Librarian
//
//  Created by Vanshaj on 09/07/24.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseFirestore


@MainActor
final class InventoryViewModel: ObservableObject {
    @Published var books: [BookMetaData] = []
    @Published var allBooks: [BookMetaData] = []
    @Published var searchQuery: String = "" {
        didSet {
            searchBooks(query: searchQuery)
        }
    }
    
    private let bookMetaDataService = BookMetaDataService()
    
    func updateInventoryTableView(isbnList: [String]) async {
        do {
            print("Fetched ISBN List: \(isbnList)")
            let completeData = await self.bookMetaDataService.getCompleteBookMetadata(isbnList: isbnList)
            print("Fetched Complete Data Count: \(completeData.count)")
            await MainActor.run {
//                self.books.removeAll()
                self.books = completeData
                self.allBooks = completeData
                print("Updated UI with \(self.books.count) books")
            }
        }
    }
    
    func searchBooks(query: String) {
        if query.isEmpty {
            self.books = self.allBooks
            return
        }
        
        let lowercasedQuery = query.lowercased()
        self.books = self.allBooks.filter { book in
            book.title.lowercased().contains(lowercasedQuery) ||
            book.authors.lowercased().contains(lowercasedQuery) ||
            book.genre.lowercased().contains(lowercasedQuery)
        }
    }
}
