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

class InventoryViewModel: ObservableObject {
    @Published var books: [BookMetaData] = []
    @Published var searchQuery: String = ""

    init() {
        fetchBookDetails()
    }
    
    func fetchBookDetails() {
        LibraryBooks.removeAll()
        fetchBooks { [weak self] books, error in
            guard let books = books else {
                print("Error fetching books: \(String(describing: error))")
                return
            }

            let dispatchGroup = DispatchGroup()
            var updatedBooks: [BookMetaData] = []

            for bookRecord in books {
                dispatchGroup.enter()
                print("DispatchGroup enter for ISBN: \(bookRecord.isbnOfTheBook)")
                fetchBookDataFromAPI(isbn: bookRecord.isbnOfTheBook) { bookFromAPI in
                    let volumeInfo = bookFromAPI?.items.first?.volumeInfo
                    let newBook = BookMetaData(
                        title: volumeInfo?.title ?? "-",
                        authors: volumeInfo?.authors.first ?? "-",
                        genre: volumeInfo?.categories.first ?? "-",
                        publishedDate: volumeInfo?.publishedDate ?? "-",
                        pageCount: volumeInfo?.pageCount ?? 0,
                        language: volumeInfo?.language ?? "...",
                        coverImageLink: volumeInfo?.imageLinks.thumbnail ?? "...",
                        isbn: bookRecord.isbnOfTheBook,
                        totalNumberOfCopies: bookRecord.totalNumberOfCopies,
                        numberOfIssuedCopies: bookRecord.numberOfIssuedCopies,
                        bookColumn: bookRecord.bookColumn,
                        bookShelf: bookRecord.bookShelf
                    )
                    print("Fetched book details: \(newBook)")
                    updatedBooks.append(newBook)
                    dispatchGroup.leave()
                    print("DispatchGroup leave for ISBN: \(bookRecord.isbnOfTheBook)")
                }
            }

            DispatchQueue.main.async {
                print("DispatchGroup main called")
                self?.books = updatedBooks
                print("Books fetched: \(updatedBooks)")
            }
//            dispatchGroup.notify(queue: .main) {
//                print("DispatchGroup notify called")
//                self?.books = updatedBooks
//                print("Books fetched: \(updatedBooks)")
//            }
        }
    }
}


func fetchBookDataFromAPI(isbn: String, completion: @escaping (BooksAPI?) -> Void) {
    BookSearchManager().getBookInfo(isbn: isbn) { books in
        print("Fetched data from API for ISBN \(isbn): \(String(describing: books))")
        completion(books)
    }
    
    
    
}

// nested structure to fetch data from API
struct BooksAPI: Decodable {
    let items: [BookItem]
}

struct BookItem: Decodable {
    let id: String
    let volumeInfo: VolumeInfo
}

// to store data from the API to further use it in front-end
struct BookMetaData: Identifiable {
    var id = UUID() // to conform to Identifiable
    
    var title: String
    var authors: String
    var genre: String
    var publishedDate: String
    var pageCount: Int
    var language: String
    let coverImageLink: String
    let isbn: String
    var totalNumberOfCopies: Int
    let numberOfIssuedCopies: Int
    var bookColumn: String
    var bookShelf: String
}

// array of instances for the books available in the library
var LibraryBooks: [BookMetaData] = []
var bookDataFromAPI : BooksAPI?

struct VolumeInfo: Decodable {
    let title: String
    let subtitle: String?
    let authors: [String]
    let publishedDate: String
    let pageCount: Int
    let language: String
    let imageLinks: ImageLinks
    let categories: [String]
}

struct ImageLinks: Decodable {
    let smallThumbnail: String
    let thumbnail: String
}
