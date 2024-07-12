//
//  BookSearchManager.swift
//  LMSAdmin
//
//  Created by Hitesh Rupani on 04/07/24.
//

import Foundation

final class BookMetaDataService {
    private let googleBookService: GoogleBookService = GoogleBookService()
    private let firestoreService: FirestoreService = FirestoreService()
    
    func getCompleteBookMetadata(isbnList: [String]) async -> [BookMetaData] {
        var bookMetaDataList : [BookMetaData] = []
        
        await withTaskGroup(of: BookMetaData?.self) { group in
            for isbn in isbnList {
                group.addTask {
                    do {
                        async let googleBookServiceFetchData = self.googleBookService.createGoogleBookMetaData(isbn: isbn)
                        async let firestoreServiceFetchData = self.firestoreService.getBookDetails(isbn: isbn)
                        
                        let combinedGoogleBookServiceData = try await googleBookServiceFetchData
                        let combinedFirestoreServiceData = try await firestoreServiceFetchData
                        return BookMetaData(googleBookMetaData: combinedGoogleBookServiceData, firestoreMetadata: combinedFirestoreServiceData)
                    }catch {
                        print("Error fetching data for ISBN \(isbn): \(error)")
                        return nil
                    }
                }
            }
            for await result in group {
                if let bookMetaData = result {
                    bookMetaDataList.append(bookMetaData)
                }
            }
        }
        return bookMetaDataList
    }
}
