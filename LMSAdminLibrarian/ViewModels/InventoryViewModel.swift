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
    @Published var searchQuery: String = ""
    
    private let bookMetaDataService = BookMetaDataService()
    
    
    func updateInventoryTableView(isbnList: [String]) async {
        do {
            
            print("Fetched ISBN List: \(isbnList)")
            let completeData = await self.bookMetaDataService.getCompleteBookMetadata(isbnList: isbnList)
            print("Fetched Complete Data Count: \(completeData.count)")
            await MainActor.run {
                self.books = completeData
                print("Updated UI \(self.books.count) books")
            }
        }
    }
}

