////
////  QRStruct.swift
////  LMSAdminLibrarian
////
////  Created by ttcomputer on 16/07/24.
////
//
//import Foundation
//
//// Original struct
//struct QRkData: Codable {
//    var isbn: String
//    var userId: String
//    var currentTime: String
//    var date: String
//    
//    func addDaysToDate() -> String {
//         let dateFormatter = DateFormatter()
//         dateFormatter.dateFormat = "yyyy-MM-dd" // Adjust the date format to match your input string
//         
//         if let originalDate = dateFormatter.date(from: date) {
//             let newDate = Calendar.current.date(byAdding: .day, value: 30, to: originalDate)!
//             let newDateString = dateFormatter.string(from: newDate)
//             return newDateString
//         } else {
//             return "Invalid date format"
//         }
//     }
//}
//
//// Struct to match the JSON structure
//struct ScannedQRData: Codable {
//    var userId: String
//    var isbn: String
//    var timestamp: String
//    var date: String
//}
//
//
