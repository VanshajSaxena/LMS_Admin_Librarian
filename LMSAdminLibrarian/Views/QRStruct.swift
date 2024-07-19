//
//  QRStruct.swift
//  LMSAdminLibrarian
//
//  Created by ttcomputer on 16/07/24.
//

import Foundation

// Original struct
struct QRData: Codable, Identifiable {
    var id: String { isbn }
    var isbn: String
    var userId: String
    var currentTime: String
    var date: String
    var hasReturned: Bool
    
    func addDaysToDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        if let originalDate = dateFormatter.date(from: date) {
            let newDate = Calendar.current.date(byAdding: .day, value: 30, to: originalDate)!
            let newDateString = dateFormatter.string(from: newDate)
            return newDateString
        } else {
            return "Invalid date format"
        }
    }
}


// Struct to match the JSON structure
struct ScannedQRData: Codable {
    var userId: String
    var isbn: String
    var timestamp: String
    var date: String
    var hasReturned: Bool
   
}


