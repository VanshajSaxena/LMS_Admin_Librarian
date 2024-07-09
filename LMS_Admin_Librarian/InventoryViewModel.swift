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

    // Example usage

    init() { }
    
    func fetchBookDetailsList(isbnList: [String]) {
    let dispatchGroup = DispatchGroup()
    var bookDetailsList: [BookMetaData] = []
    
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
                    bookDetailsList.append(bookMetaData)
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
        books =  bookDetailsList
}

    func fetchBookDetails(isbnList: [String], completion: @escaping ([BookMetaData]) -> Void) {
    let dispatchGroup = DispatchGroup()
    var bookDetailsList: [BookMetaData] = []
    
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
                    bookDetailsList.append(bookMetaData)
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
        completion(bookDetailsList)
    }
}

}


func fetchBookDataFromAPI(isbn: String, completion: @escaping (BooksAPI?) -> Void) {
    BookSearchManager().getBookInfo(isbn: isbn) { books in
        print("Fetched data from API for ISBN \(isbn): \(String(describing: books))")
        completion(books)
    }
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

struct BookMetaData : Identifiable {
    let id: String
    let title: String
    let authors: String
    let genre: String
    let publishedDate: String
    let pageCount: Int
    let language: String
    let coverImageLink: String
    let isbn: String
    let totalNumberOfCopies: Int
    let numberOfIssuedCopies: Int
    let bookColumn: String
    let bookShelf: String
}

var LibraryBooks: [BookMetaData] = []
var bookDataFromAPI : BooksAPI?

// Assuming you have these types already defined
struct BooksAPI: Codable {
    let items: [BookItem]
}

struct BookItem: Codable {
    let id: String
    let volumeInfo: VolumeInfo
}

struct VolumeInfo: Codable {
    let title: String
    let authors: [String]
    let publishedDate: String
    let pageCount: Int
    let language: String
    let imageLinks: ImageLinks?
    let categories: [String]?
}

struct ImageLinks: Codable {
    let smallThumbnail: String?
    let thumbnail: String?
}

let isbnList = [
    "9780061120084",
    "9780062316097",
    "9780141439518",
    "9780307474278",
    "9780345391803",
    "9780385490818",
    "9780451524935",
    "9780590353427",
    "9780618640157",
    "9780670097111",
    "9780743273565"
]
