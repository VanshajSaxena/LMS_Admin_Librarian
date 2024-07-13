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
class InventoryViewModel: ObservableObject {
    @Published var books: [BookMetaData] = []
    @Published var searchQuery: String = ""
    
    private let bookMetaDataService = BookMetaDataService()
    
    
    func updateInventoryTableView(isbnList: [String]) {
        Task {
            let completeData = await self.bookMetaDataService.getCompleteBookMetadata(isbnList: isbnList)
            DispatchQueue.main.async {
                self.books = completeData
            }
        }
        
    }
}
