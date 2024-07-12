//
//  Structs.swift
//  LMSAdmin
//
//  Created by Hitesh Rupani on 04/07/24.
//

/*

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

        // Use DispatchGroup to manage multiple asynchronous calls
        let dispatchGroup = DispatchGroup()
        
        var updatedBooks: [BookMetaData] = []

        for bookRecord in books {
            dispatchGroup.enter()
            fetchBookDataFromAPI(isbn: bookRecord.isbnOfTheBook) { bookFromAPI in
                updatedBooks.append(BookMetaData(
                    title: bookFromAPI?.items.first?.volumeInfo.title ?? "-",
                    authors: bookFromAPI?.items.first?.volumeInfo.authors.first ?? "-",
                    genre: bookFromAPI?.items.first?.volumeInfo.categories.first ?? "-",
                    publishedDate: bookFromAPI?.items.first?.volumeInfo.publishedDate ?? "-",
                    pageCount: bookFromAPI?.items.first?.volumeInfo.pageCount ?? 0,
                    language: bookFromAPI?.items.first?.volumeInfo.language ?? "...",
                    coverImageLink: bookFromAPI?.items.first?.volumeInfo.imageLinks.thumbnail ?? "...",
                    isbn: bookRecord.isbnOfTheBook,
                    totalNumberOfCopies: bookRecord.totalNumberOfCopies,
                    numberOfIssuedCopies: bookRecord.numberOfIssuedCopies,
                    bookColumn: bookRecord.bookColumn,
                    bookShelf: bookRecord.bookShelf
                ))
                dispatchGroup.leave()
            }
        }

        dispatchGroup.notify(queue: .main) {
            LibraryBooks = updatedBooks
        }
    }
}

// MARK: - FireStore Database

var BooksFromDB: [BookRecord] = [] {
    didSet{
        print("Updated")
    }
}

// MARK: - Google Books API

// ISBN from DB to be used
var isbnForAPI: String = "..."

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

*/

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
    let description: String
}

struct ImageLinks: Codable {
    let smallThumbnail: String?
    let thumbnail: String?
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
    let description: String
    let isbn: String
    let totalNumberOfCopies: Int
    let numberOfIssuedCopies: Int
    let bookColumn: String
    let bookShelf: String
    
    init(googleBookMetaData: GoogleBookMetaData, firestoreMetadata: FirestoreMetadata) {
        self.id = googleBookMetaData.id
        self.title = googleBookMetaData.title
        self.authors = googleBookMetaData.authors
        self.genre = googleBookMetaData.genre
        self.publishedDate = googleBookMetaData.publishedDate
        self.pageCount = googleBookMetaData.pageCount
        self.language = googleBookMetaData.language
        self.coverImageLink = googleBookMetaData.coverImageLink
        self.description = googleBookMetaData.description
        self.isbn = googleBookMetaData.isbn
        self.totalNumberOfCopies = firestoreMetadata.totalNumberOfCopies
        self.numberOfIssuedCopies = firestoreMetadata.numberOfIssuedCopies
        self.bookColumn = firestoreMetadata.bookColumn
        self.bookShelf = firestoreMetadata.bookShelf
    }
}

struct GoogleBookMetaData {
        let id: String
        let title: String
        let authors: String
        let genre: String
        let publishedDate: String
        let pageCount: Int
        let language: String
        let coverImageLink: String
        let description: String
        let isbn: String
    }

struct FirestoreMetadata {
    var isbn: String
    var totalNumberOfCopies: Int
    var numberOfIssuedCopies: Int
    var bookColumn: String
    var bookShelf: String
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
