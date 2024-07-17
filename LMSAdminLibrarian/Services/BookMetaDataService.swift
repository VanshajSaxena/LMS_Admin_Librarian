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
        var bookMetaDataList: [BookMetaData] = []
        var errors: [String: Error] = [:]
        
        await withTaskGroup(of: (String, Result<BookMetaData, Error>).self) { group in
            for isbn in isbnList {
                group.addTask {
                    do {
                        async let firestoreServiceFetchData = self.firestoreService.getBookDetails(isbn: isbn)
                        async let googleBookServiceFetchData = self.googleBookService.createGoogleBookMetaData(isbn: isbn)

                        let combinedFirestoreServiceData = try await firestoreServiceFetchData
                        let combinedGoogleBookServiceData = try await googleBookServiceFetchData
                        let bookMetaData = BookMetaData(googleBookMetaData: combinedGoogleBookServiceData, firestoreMetadata: combinedFirestoreServiceData)
                        return (isbn, .success(bookMetaData))
                    } catch {
                        return (isbn, .failure(error))
                    }
                }
            }
            
            for await result in group {
                switch result.1 {
                case .success(let bookMetaData):
                    bookMetaDataList.append(bookMetaData)
                case .failure(let error):
                    errors[result.0] = error
                }
            }
        }
        
        print("Successfully fetched \(bookMetaDataList.count) books")
        print("Errors occurred for \(errors.count) ISBNs:")
        for (isbn, error) in errors {
            print("ISBN \(isbn): \(error.localizedDescription)")
        }
        
        return bookMetaDataList
    }
}
