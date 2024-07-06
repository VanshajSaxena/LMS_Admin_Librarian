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
    // Other properties...
    
    var dictionary: [String: Any] {
        return [
            "totalNumberOfCopies": totalNumberOfCopies,
            "numberOfIssuedCopies": numberOfIssuedCopies,
            "isbnOfTheBook": isbnOfTheBook,
            // Other properties...
        ]
    }
}

let filepath = "/Users/vanshaj/Documents/Book (4).xlsx"

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
                var totalNumberOfCopies: Int?
                var numberOfIssuedCopies: Int?
                var isbnOfTheBook: String?

                // Find the indices of the required columns
                if let headerRow = worksheet.data?.rows.first {
                    for (index, cell) in headerRow.cells.enumerated() {
                        let value = cell.stringValue(sharedStrings!)?.lowercased()
                        if value == "isbn" {
                            isbnOfTheBook = String(index)
                        } else if value == "total number of copies" {
                            totalNumberOfCopies = index
                        } else if value == "number of issued copies" {
                            numberOfIssuedCopies = index
                        }
                    }
                }

                // Ensure all required columns are found
                guard let ISBNIdx = isbnOfTheBook, let TNOCIdx = totalNumberOfCopies, let NOICIdx = numberOfIssuedCopies else {
                    print("Required columns not found")
                    return
                }

                // Iterate over rows starting from the second row
                for row in worksheet.data?.rows.dropFirst() ?? [] {
                    if row.cells.count > max(Int(ISBNIdx)!, TNOCIdx, NOICIdx) { // Ensure there are enough cells in the row
                        let book = BookRecord (
                            isbnOfTheBook: row.cells[Int(ISBNIdx)!].stringValue(sharedStrings!) ?? "NOContent",
                            totalNumberOfCopies: Int(row.cells[TNOCIdx].stringValue(sharedStrings!) ?? "NOContent") ?? 0,
                            numberOfIssuedCopies: Int(row.cells[NOICIdx].stringValue(sharedStrings!) ?? "NOContent") ?? 0
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
