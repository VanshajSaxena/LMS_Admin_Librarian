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
    
//    func getBookDetailsList(isbnList: [String]) async {
//        let bookSearchService = BookMetaDataService()
//        await withTaskGroup(of: BookMetaData?.self) { group in
//            for isbn in isbnList {
//                group.addTask {
//                    do {
//                        let bookAPI = try await 
//                        if let bookItem = bookAPI.items.first {
//                            let volumeInfo = bookItem.volumeInfo
//                            let coverImageLink = volumeInfo.imageLinks?.thumbnail ?? "URL_TO_PLACEHOLDER_IMAGE"
//                            let bookMetaData = BookMetaData(
//                                id: UUID().uuidString,
//                                title: volumeInfo.title,
//                                authors: volumeInfo.authors.joined(separator: ", "),
//                                genre: volumeInfo.categories?.first ?? "Unknown",
//                                publishedDate: volumeInfo.publishedDate,
//                                pageCount: volumeInfo.pageCount,
//                                language: volumeInfo.language,
//                                coverImageLink: coverImageLink,
//                                description: volumeInfo.description,
//                                isbn: isbn,
//                                totalNumberOfCopies: Int.random(in: 10...30), //
//                                numberOfIssuedCopies: 0,
//                                bookColumn: "A",
//                                bookShelf: "1")
//                            print(bookMetaData)
//                            return bookMetaData
//                        }
//                    } catch {
//                        print("Error: \(error.localizedDescription)")
//                    }
//                    return nil
//                }
//            }
//            for await result in group {
//                if let bookMetaData = result {
//                    self.books.append(bookMetaData)
//                }
//            }
//        }
//    }
}


    /*
    func fetchBookDetailsList(isbnList: [String]) {
    let dispatchGroup = DispatchGroup()
    for isbn in isbnList {
        dispatchGroup.enter()
        print("DispatchGroup enter for ISBN: \(isbn)")
        
        fetchBookData(for: isbn) { result in
            switch result {
            case .success(let booksAPI):
                if let bookItem = booksAPI.items.first {
                    let volumeInfo = bookItem.volumeInfo
                    
                    let coverImageLink = volumeInfo.imageLinks?.thumbnail ?? "URL_TO_PLACEHOLDER_IMAGE"
                    let bookMetaData = BookMetaData(
                        id: UUID().uuidString,
                        title: volumeInfo.title,
                        authors: volumeInfo.authors.joined(separator: ", "),
                        genre: volumeInfo.categories?.first ?? "Unknown",
                        publishedDate: volumeInfo.publishedDate,
                        pageCount: volumeInfo.pageCount,
                        language: volumeInfo.language,
                        coverImageLink: coverImageLink,
                        isbn: isbn,
                        totalNumberOfCopies: Int.random(in: 10...30), // Assuming you generate these values
                        numberOfIssuedCopies: 0,
                        bookColumn: "A", // Example, customize as needed
                        bookShelf: "1"   // Example, customize as needed
                    )
                    
                    print("Fetched book details: \(bookMetaData)")
                    self.books.append(bookMetaData)
                }
            case .failure(let error):
                print("Error fetching data for ISBN \(isbn): \(error)")
            }
            
            print("DispatchGroup leave for ISBN: \(isbn)")
            dispatchGroup.leave()
        }
        
    }
    
    dispatchGroup.notify(queue: .main) {
        print("All book details have been fetched.")
//        completion(bookDetailsList)
        
    }



// Function to fetch book data from API
func fetchBookData(for isbn: String, completion: @escaping (Result<BooksAPI, Error>) -> Void) {
    let urlString = "https://www.googleapis.com/books/v1/volumes?q=isbn:\(isbn)"
    guard let url = URL(string: urlString) else {
        completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
        return
    }

    URLSession.shared.dataTask(with: url) { data, response, error in
        if let error = error {
            completion(.failure(error))
            return
        }

        guard let data = data else {
            completion(.failure(NSError(domain: "No Data", code: -1, userInfo: nil)))
            return
        }

        do {
            let booksAPI = try JSONDecoder().decode(BooksAPI.self, from: data)
            completion(.success(booksAPI))
        } catch {
            completion(.failure(error))
        }
    }.resume()
}

*/
// Assuming you have these types already defined
