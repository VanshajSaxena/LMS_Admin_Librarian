//
//  QRStruct.swift
//  LMSAdminLibrarian
//
//  Created by ttcomputer on 16/07/24.
//

import Foundation

// Original struct
struct QRkData: Codable {
    var isbn: String
    var userId: String
    var currentTime: String
    var date: String
}

// Struct to match the JSON structure
struct ScannedQRData: Codable {
    var userId: String
    var isbn: String
    var timestamp: String
    var date: String
}

struct Record: Identifiable {
    var id = UUID()
    var userId: String
    var isbnNumber: String
    var issueDate: String
    var issuedTime: String
    var returnDate: String
}

