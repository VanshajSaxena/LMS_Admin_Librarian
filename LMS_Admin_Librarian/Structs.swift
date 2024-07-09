//
//  Structs.swift
//  LMSAdmin
//
//  Created by Hitesh Rupani on 04/07/24.
//

import Foundation

import Foundation
import SwiftUI
import Firebase
import FirebaseFirestore

// array of instances for the books available in the library
var LibraryBooks: [BookMetaData] = []
var bookDataFromAPI : BooksAPI?

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

// to get book details from backend to front-end
func fetchBookDetails() {
    LibraryBooks.removeAll()
    fetchBooks { books, error in
        guard let books = books else {
            print("Error fetching books: \(String(describing: error))")
            return
        }
        
        //        DispatchQueue.main.async {
        BooksFromDB = books // Ensure BooksFromDB is updated on the main thread
//        LibraryBooks.removeAll()
        for bookRecord in books {
            let bookFromAPI = fetchBookDataFromAPI(isbn: bookRecord.isbnOfTheBook)
            LibraryBooks.append(BookMetaData(title: bookFromAPI?.items.first?.volumeInfo.title ?? "-",
                                             authors: bookFromAPI?.items.first?.volumeInfo.authors.first ?? "-",
                                             genre: bookFromAPI?.items.first?.volumeInfo.categories.first ?? "-",
                                             publishedDate: bookFromAPI?.items.first?.volumeInfo.publishedDate ?? "-",
                                             pageCount: bookFromAPI?.items.first?.volumeInfo.pageCount ?? 0,
                                             language: bookFromAPI?.items.first?.volumeInfo.language ?? "...",
                                             coverImageLink: bookFromAPI?.items.first?.volumeInfo.imageLinks.thumbnail ?? "...",
                                             isbn: isbnForAPI,
                                             totalNumberOfCopies: bookRecord.totalNumberOfCopies,
                                             numberOfIssuedCopies: bookRecord.numberOfIssuedCopies,
                                             bookColumn: bookRecord.bookColumn,
                                             bookShelf: bookRecord.bookShelf))
        }
        //        }
    }
    //    for bookRecord in BooksFromDB {
    //      let isbn = bookRecord.isbnOfTheBook
    //        fetchBookDataFromAPI(isbn: isbn)
    //    }
    
}

// MARK: - FireStore Database

var BooksFromDB: [BookRecord] = [] {
    didSet{
        print("Updated")
    }
}

// to store data from the DB
//struct BookRecord {
//    let isbnOfTheBook: String
//    let totalNumberOfCopies: Int
//    let numberOfIssuedCopies: Int
//    let bookColumn: String
//    let bookShelf: String
//    // Other properties...
//    
//    var dictionary: [String: Any] {
//        return [
//            "isbnOfTheBook": isbnOfTheBook,
//            "totalNumberOfCopies": totalNumberOfCopies,
//            "numberOfIssuedCopies": numberOfIssuedCopies,
//            "bookColumn": bookColumn,
//            "bookShelf": bookShelf,
//        ]
//    }
//}

// fetching books data
//func fetchBooks(completion: @escaping ([BookRecord]?, Error?) -> Void) {
//    let db = Firestore.firestore()
//    db.collection("books").getDocuments { snapshot, error in
//        if let error = error {
//            print("Error getting documents: \(error)")
//            completion(nil, error)
//        } else {
//            var books: [BookRecord] = []
//            for document in snapshot!.documents {
//                let data = document.data()
//                if let isbnOfTheBook = data["isbnOfTheBook"] as? String,
//                   let numberOfIssuedCopies = data["numberOfIssuedCopies"] as? Int,
//                   let totalNumberOfCopies = data["totalNumberOfCopies"] as? Int,
//                   let bookColumn = data["bookColumn"] as? String,
//                   let bookShelf = data["bookShelf"] as? String {
//                    let book = BookRecord(isbnOfTheBook: isbnOfTheBook, totalNumberOfCopies: totalNumberOfCopies, numberOfIssuedCopies: numberOfIssuedCopies, bookColumn: bookColumn, bookShelf: bookShelf)
//                    books.append(book)
//                }
//            }
//            completion(books, nil)
//        }
//    }
//}

// MARK: - Google Books API

// ISBN from DB to be used
var isbnForAPI: String = "..."

// book data fetched from API
//var bookFromAPI: BooksAPI?  {
//    didSet {
//        // appending data in LibraryBooks
//        LibraryBooks.append(BookMetaData(title: bookFromAPI?.items.first?.volumeInfo.title ?? "-",
//                                         authors: bookFromAPI?.items.first?.volumeInfo.authors.first ?? "-",
//                                         genre: bookFromAPI?.items.first?.volumeInfo.categories.first ?? "-",
//                                         publishedDate: bookFromAPI?.items.first?.volumeInfo.publishedDate ?? "-",
//                                         pageCount: bookFromAPI?.items.first?.volumeInfo.pageCount ?? 0,
//                                         language: bookFromAPI?.items.first?.volumeInfo.language ?? "...",
//                                         coverImageLink: bookFromAPI?.items.first?.volumeInfo.imageLinks.thumbnail ?? "...",
//                                         isbn: isbnForAPI))
//        print("Aaaaaaaaaaaaaaaa: ", LibraryBooks)
//    }
//}

func fetchBookDataFromAPI(isbn: String) -> BooksAPI? {
    BookSearchManager().getBookInfo(isbn: isbn) { books in
        //        DispatchQueue.main.async {
        //            bookFromAPI = books
        //
        ////            print(books.items.first?.volumeInfo ?? "didn't work")
        //        }
        bookDataFromAPI = books
    }
    return bookDataFromAPI
}

// nested structure to fetch data from API
struct BooksAPI: Decodable {
    let items: [BookItem]
}

struct BookItem: Decodable {
    let id: String
    let volumeInfo: VolumeInfo
}

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


//struct BooksAPI: Decodable {
//    let items: [BookItem]
//}
//
//struct BookItem: Decodable {
//    let id: String
//    let volumeInfo: VolumeInfo
//}
//
//struct VolumeInfo: Decodable {
//    let title: String
//    let subtitle: String?
//    let authors: [String]
//    let publishedDate: String
//    let pageCount: Int
//    let language: String
//    let imageLinks: ImageLinks
//}
//
//struct ImageLinks: Decodable {
//    let smallThumbnail: String
//    let thumbnail: String
//}
