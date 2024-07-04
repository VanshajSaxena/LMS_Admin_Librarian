//
//  ExcelToFirebase.swift
//  LMS_Admin_Librarian
//
//  Created by Vanshaj on 04/07/24.
//

import Foundation
import FirebaseFirestore
import CoreXLSX

struct Book {
    let title: String
    let author: String
    let isbn: String
    // Other properties...
        
    var dictionary: [String: Any] {
        return [
            "title": title,
            "author": author,
            "isbn": isbn,
            // Other properties...
        ]
    }
}

let filepath = "/Users/vanshaj/Documents/Book (2).xlsx"
func parseExcelFile(at url: URL, completion: @escaping ([Book]) -> Void) {
    do {
        guard let file = XLSXFile(filepath: url.path) else {
            print("Failed to open file.")
            return
        }
        
        var books: [Book] = []
        let workbooks = try file.parseWorkbooks()
        let sharedStrings = (try file.parseSharedStrings())!
        
        for workbook in workbooks {
            let worksheetPathsAndNames = try file.parseWorksheetPathsAndNames(workbook: workbook)
            
            for (_, path) in worksheetPathsAndNames {
                let worksheet = try file.parseWorksheet(at: path)
                
                for row in worksheet.data?.rows ?? [] {
                    if row.reference == 0 {}
                    else {
                        let book = Book(
                            title: row.cells[0].stringValue(sharedStrings) ?? "",
                            author: row.cells[1].stringValue(sharedStrings) ?? "",
                            isbn: row.cells[2].stringValue(sharedStrings) ?? ""
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

func updateFirestore(with books: [Book]) {
        let db = Firestore.firestore()
        let batch = db.batch()
        
        for book in books {
            let docRef = db.collection("books").document(book.isbn)
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
