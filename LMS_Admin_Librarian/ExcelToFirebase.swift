//
//  ExcelToFirebase.swift
//  LMS_Admin_Librarian
//
//  Created by Vanshaj on 04/07/24.
//

import Foundation
import FirebaseFirestore
import CoreXLSX

struct BookMetaData {
    let title: String
    let authors: String
    let publishedDate: String
    let pageCount: String
    let language: String
    let imageLinks: String
    let isbn: String
}

struct BookRecord {
    let isbnOfTheBook: String
    let totalNumberOfCopies: Int
    let numberOfIssuedCopies: Int
    let bookColumn: String
    let bookShelf: String
    // Other properties...
    
    var dictionary: [String: Any] {
        return [
            "isbnOfTheBook": isbnOfTheBook,
            "totalNumberOfCopies": totalNumberOfCopies,
            "numberOfIssuedCopies": numberOfIssuedCopies,
            "bookColumn": bookColumn,
            "bookShelf": bookShelf,
        ]
    }
}

let filepath = "/Users/vanshaj/Documents/Book (5).xlsx"

func parseExcelFile(at url: URL, completion: @escaping ([BookRecord]) -> Void) {
    do {
        guard let file = XLSXFile(filepath: url.path) else {
            print("Failed to open file.")
            return
        }

        // Load shared strings
        let sharedStrings = try file.parseSharedStrings()
        
        var books: [BookRecord] = []
        let workbooks = try file.parseWorkbooks()
        
        for workbook in workbooks {
            let worksheetPathsAndNames = try file.parseWorksheetPathsAndNames(workbook: workbook)
            
            for (_, path) in worksheetPathsAndNames {
                let worksheet = try file.parseWorksheet(at: path)
                var totalNumberOfCopiesIdx: Int?
                var numberOfIssuedCopiesIdx: Int?
                var isbnOfTheBookIdx: Int?
                var bookColumnIdx: Int?
                var bookShelfIdx: Int?

                // Find the indices of the required columns
                if let headerRow = worksheet.data?.rows.first {
                    for (index, cell) in headerRow.cells.enumerated() {
                        let value = cell.stringValue(sharedStrings!)?.lowercased()
                        if value == "isbn" {
                            isbnOfTheBookIdx = index
                        } else if value == "total number of copies" {
                            totalNumberOfCopiesIdx = index
                        } else if value == "number of issued copies" {
                            numberOfIssuedCopiesIdx = index
                        } else if value == "book column" {
                            bookColumnIdx = index
                        } else if value == "book shelf" {
                            bookShelfIdx = index
                        }
                    }
                }

                // Ensure all required columns are found
                guard let isbnIdx = isbnOfTheBookIdx, let tnocIdx = totalNumberOfCopiesIdx, let noicIdx = numberOfIssuedCopiesIdx, let bcIdx = bookColumnIdx, let bsIdx = bookShelfIdx else {
                    print("Required columns not found")
                    completion([])
                    return
                }

                // Iterate over rows starting from the second row
                for row in worksheet.data?.rows.dropFirst() ?? [] {
                    if row.cells.count > max(isbnIdx, tnocIdx, noicIdx, bcIdx, bsIdx) { // Ensure there are enough cells in the row
                        let book = BookRecord(
                            isbnOfTheBook: row.cells[isbnIdx].stringValue(sharedStrings!) ?? "NOContent",
                            totalNumberOfCopies: Int(row.cells[tnocIdx].stringValue(sharedStrings!) ?? "0") ?? 0,
                            numberOfIssuedCopies: Int(row.cells[noicIdx].stringValue(sharedStrings!) ?? "0") ?? 0,
                            bookColumn: row.cells[bcIdx].stringValue(sharedStrings!) ?? "NOContent",
                            bookShelf: row.cells[bsIdx].stringValue(sharedStrings!) ?? "NOContent"
                            // Other properties...
                        )
                        books.append(book)
                    }
                }
            }
        }
        completion(books)
    } catch {
        print("Error parsing Excel file: \(error)")
        completion([])
    }
}

func updateFirestore(with books: [BookRecord]) {
    let db = Firestore.firestore()
    let batch = db.batch()
    
    for book in books {
        let docRef = db.collection("books").document(book.isbnOfTheBook)
        batch.setData(book.dictionary, forDocument: docRef)
    }
    
    batch.commit { error in
        if let error = error {
            print("Error writing batch \(error)")
        } else {
            print("Batch write succeeded.")
        }
    }
}

func fetchBooks(completion: @escaping ([BookRecord]?, Error?) -> Void) {
    let db = Firestore.firestore()
    db.collection("books").getDocuments { snapshot, error in
        if let error = error {
            print("Error getting documents: \(error)")
            completion(nil, error)
        } else {
            var books: [BookRecord] = []
            for document in snapshot!.documents {
                let data = document.data()
                if let isbnOfTheBook = data["isbnOfTheBook"] as? String,
                   let numberOfIssuedCopies = data["numberOfIssuedCopies"] as? Int,
                   let totalNumberOfCopies = data["totalNumberOfCopies"] as? Int,
                   let bookColumn = data["bookColumn"] as? String,
                   let bookShelf = data["bookShelf"] as? String {
                    let book = BookRecord(isbnOfTheBook: isbnOfTheBook, totalNumberOfCopies: totalNumberOfCopies, numberOfIssuedCopies: numberOfIssuedCopies, bookColumn: bookColumn, bookShelf: bookShelf)
                    books.append(book)
                }
            }
            completion(books, nil)
        }
    }
}
