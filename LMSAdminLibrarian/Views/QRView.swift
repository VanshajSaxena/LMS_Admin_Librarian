////
////  QRView.swift
////  LMSAdminLibrarian
////
////  Created by ttcomputer on 16/07/24.
////
//
//import SwiftUI
//
//struct Scanner: View {
//    var body: some View {
//        VStack {
//            HeaderView()
//            
//            IssueSection()
//            
//           // RecordSection()
//
//        }
//        .padding()
//        .background(Color(.systemGray6))
//    }
//}
//
//struct HeaderView: View {
//    var body: some View {
//        HStack {
//            Spacer()
//            
//            HStack {
//                Button(action: {}){
//                    Image(systemName: "bell")
//                        .resizable()
//                        .frame(width: 24, height: 24)
//                }
//                .padding()
//                Button(action: {}) {
//                    HStack {
//                        Image(systemName: "person.crop.circle")
//                        Text("My Account")
//                    }
//                    .padding()
//                    .background(Color.orange)
//                    .foregroundColor(.white)
//                    .cornerRadius(8)
//                }
//            }
//        }
//    }
//}
//
//struct IssueSection: View {
//  
//    @State private var showingImagePicker = false
//    @State private var showingQRScanner = false
//    @State private var scannedQRCode: String = ""
//    @State private var scannedData = [QRkData]()
//    
//    var body: some View {
//        VStack(alignment: .leading, spacing: 30) {
//            Text("Issue")
//                .font(.largeTitle)
//                .bold()
//            
//            HStack(spacing: 20) {
//                IssueButton(title: "Scan QR", systemImageName: "qrcode.viewfinder", backgroundColor: .orange) {
//                    self.showingQRScanner = true
//                }
//                 .sheet(isPresented: $showingQRScanner) {
//                    QRScannerView { scannedCode in
//                        if let data = processQRCode(scannedCode) {
//                            scannedData.append(data)
//                            print("Scanned Data Array: \(scannedData)")
//                        } else {
//                            print("Failed to process QR code")
//                        }
//                        showingQRScanner = false
//                    }
//                }
//                
//                List(scannedData, id: \.isbn) { data in
//                    VStack(alignment: .leading) {
//                        Text("ISBN: \(data.isbn)")
//                        Text("User ID: \(data.userId)")
//                        Text("Time: \(data.currentTime)")
//                        Text("Date: \(data.date)")
//                    }
//                }
//              
//            }
//        }
//        .padding()
//        .frame(maxWidth: .infinity, alignment: .leading)
//    }
//}
//
//
//struct IssueButton: View {
//    let title: String
//    let systemImageName: String
//    let backgroundColor: Color
//    let action: () -> Void // Add action closure
//    
//    var body: some View {
//        Button(action: action) { // Use action closure in Button
//            VStack {
//                Image(systemName: systemImageName)
//                    .resizable()
//                    .frame(width: 100, height: 100)
//                    .foregroundColor(backgroundColor == .white ? .black : .white)
//                
//                Text(title)
//                    .foregroundColor(backgroundColor == .white ? .black : .white)
//                    .font(.headline)
//            }
//            .padding()
//            .frame(width: 200, height: 200)
//            .background(backgroundColor)
//            .cornerRadius(12)
//        }
//    }
//}
//
//
////  QR code scanning function
//func scanQRCodeFromImage(_ image: UIImage) -> String? {
//    guard let ciImage = CIImage(image: image) else { return nil }
//    let context = CIContext()
//    let options: [String: Any] = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
//    let qrDetector = CIDetector(ofType: CIDetectorTypeQRCode, context: context, options: options)
//    let features = qrDetector?.features(in: ciImage) as? [CIQRCodeFeature]
//    return features?.first?.messageString
//}
//
//// Process QR Code function
//func processQRCode(_ code: String) -> QRkData? {
//    print("Scanned Code: \(code)")
//    guard let jsonData = code.data(using: .utf8) else {
//        print("Failed to convert string to data")
//        return nil
//    }
//    let decoder = JSONDecoder()
//    do {
//        let scannedData = try decoder.decode(ScannedQRData.self, from: jsonData)
//        let qrData = QRkData(
//            isbn: scannedData.isbn,
//            userId: scannedData.userId,
//            currentTime: scannedData.timestamp,
//            date: scannedData.date
//        )
//        print("Decoded QR Data: \(qrData)")
//        return qrData
//    } catch {
//        print("Failed to decode QR data: \(error)")
//        return nil
//    }
//}
//
//
//
//
//
//
//struct TableViewRow: View {
//    var record: Record
//
//    var body: some View {
//        HStack {
//            Text(record.userId)
//            Spacer()
//            Text(record.isbnNumber)
//            Spacer()
//            Text(record.issueDate)
//            Spacer()
//            Text(record.issuedTime)
//            Spacer()
//            Text(record.returnDate)
//            Spacer()
//            HStack {
//                Button(action: {
//                    // Edit action
//                }) {
//                    Image(systemName: "pencil")
//                        .foregroundColor(.black)
//                }
//                // Delete button
//                Button(action: {
//                    // Delete action
//                }) {
//                    Image(systemName: "trash")
//                        .foregroundColor(.red)
//                }
//            }
//        }
//        .padding(.horizontal)
//    }
//}
//
//
//









/////////////////////////////////////////////



//
//import SwiftUI
//
//struct Scanner: View {
//    var body: some View {
//        VStack {
//            HeaderView()
//            IssueSection()
//        }
//        .padding()
//        .background(Color(.systemGray6))
//    }
//}
//
//struct HeaderView: View {
//    var body: some View {
//        HStack {
//            Spacer()
//            HStack {
//                Button(action: {}) {
//                    Image(systemName: "bell")
//                        .resizable()
//                        .frame(width: 24, height: 24)
//                }
//                .padding()
//                Button(action: {}) {
//                    HStack {
//                        Image(systemName: "person.crop.circle")
//                        Text("My Account")
//                    }
//                    .padding()
//                    .background(Color.themeOrange)
//                    .foregroundColor(.white)
//                    .cornerRadius(8)
//                }
//            }
//        }
//    }
//}
//
//struct IssueSection: View {
//    @State private var showingQRScanner = false
//    @State private var scannedData = [QRkData]()
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 30) {
//            Text("Issue Book ")
//                .font(.largeTitle)
//                .bold()
//
//            HStack(spacing: 20) {
//                IssueButton(title: "Scan QR", systemImageName: "qrcode.viewfinder", backgroundColor: Color.themeOrange) {
//                    self.showingQRScanner = true
//                }
//                .sheet(isPresented: $showingQRScanner) {
//                    QRScannerView { scannedCode in
//                        if let data = processQRCode(scannedCode) {
//                            scannedData.append(data)
//                            print("Scanned Data Array: \(scannedData)")
//                        } else {
//                            print("Failed to process QR code")
//                        }
//                        showingQRScanner = false
//                    }
//                }
//
//            }
//
//            TableView(scannedData: scannedData)
//        }
//        .padding()
//        .frame(maxWidth: .infinity, alignment: .leading)
//    }
//}
//
//
//
//
//struct TableView: View {
//    let scannedData: [QRkData]
//
//    var body: some View {
//        VStack(alignment: .leading) {
//            HStack {
//                Text("User ID")
//                Spacer()
//                Text("ISBN")
//                Spacer()
//                Text("Issue Date")
//                Spacer()
//                Text("Issue Time")
//                Spacer()
//                Text("Return Date")
//                Spacer()
//                Text("Actions")
//            }
//            .font(.headline)
//            .padding(.horizontal)
//
//            // List of TableViewRow items
//            ScrollView {
//                VStack(spacing: 0) {
//                    ForEach(scannedData, id: \.isbn) { data in
//                        TableViewRow(record: data)
//                            .padding(.horizontal)
//                            .background(Color.white)
//                            .cornerRadius(8)
//                            .shadow(radius: 2)
//                            .padding(.vertical, 4)
//                    }
//                }
//            }
//            .background(Color(.systemGray6))
//            .cornerRadius(8)
//            .shadow(radius: 4)
//            .padding(.horizontal)
//        }
//        .padding(.top, 20)
//    }
//}
//
//
//struct TableViewRow: View {
//    var record: QRkData
//
//    var body: some View {
//        HStack {
//            Text(record.userId)
//                .padding(.vertical, 8)
//            Spacer()
//            Text(record.isbn)
//                .padding(.vertical, 8)
//            Spacer()
//            Text(record.date)
//                .padding(.vertical, 8)
//            Spacer()
//            Text(record.currentTime)
//                .padding(.vertical, 8)
//            Spacer()
//            Text(record.addDaysToDate())
//                .padding(.vertical, 8)
//            Spacer()
//            HStack {
//                // Action buttons can be added here
//                Button(action: {
//                    // Delete action
//                }) {
//                    Image(systemName: "trash")
//                        .foregroundColor(.red)
//                }
//                .padding(.vertical, 8)
//            }
//        }
//        .padding(.horizontal, 16)
//    }
//}
//
//
//
//
//// QR code scanning function
//func scanQRCodeFromImage(_ image: UIImage) -> String? {
//    guard let ciImage = CIImage(image: image) else { return nil }
//    let context = CIContext()
//    let options: [String: Any] = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
//    let qrDetector = CIDetector(ofType: CIDetectorTypeQRCode, context: context, options: options)
//    let features = qrDetector?.features(in: ciImage) as? [CIQRCodeFeature]
//    return features?.first?.messageString
//}
//
//// Process QR Code function
//func processQRCode(_ code: String) -> QRkData? {
//    print("Scanned Code: \(code)")
//    guard let jsonData = code.data(using: .utf8) else {
//        print("Failed to convert string to data")
//        return nil
//    }
//    let decoder = JSONDecoder()
//    do {
//        let scannedData = try decoder.decode(ScannedQRData.self, from: jsonData)
//        let qrData = QRkData(
//            isbn: scannedData.isbn,
//            userId: scannedData.userId,
//            currentTime: scannedData.timestamp,
//            date: scannedData.date
//        )
//        print("Decoded QR Data: \(qrData)")
//        return qrData
//    } catch {
//        print("Failed to decode QR data: \(error)")
//        return nil
//    }
//}
//
//struct IssueButton: View {
//    let title: String
//    let systemImageName: String
//    let backgroundColor: Color
//    let action: () -> Void // Add action closure
//
//    var body: some View {
//        Button(action: action) { // Use action closure in Button
//            VStack {
//                Image(systemName: systemImageName)
//                    .resizable()
//                    .frame(width: 100, height: 100)
//                    .foregroundColor(backgroundColor == .white ? .black : .white)
//
//                Text(title)
//                    .foregroundColor(backgroundColor == .white ? .black : .white)
//                    .font(.headline)
//            }
//            .padding()
//            .frame(width: 200, height: 200)
//            .background(backgroundColor)
//            .cornerRadius(12)
//        }
//    }
//}


//import SwiftUI
//
//struct Scanner: View {
//    var body: some View {
//        VStack {
//            HeaderView()
//            IssueSection()
//        }
//        .padding()
//        .background(Color(.systemGray6))
//    }
//}
//
//struct HeaderView: View {
//    var body: some View {
//        HStack {
//            Spacer()
//            HStack {
//                Button(action: {}) {
//                    Image(systemName: "bell")
//                        .resizable()
//                        .frame(width: 24, height: 24)
//                }
//                .padding()
//                Button(action: {}) {
//                    HStack {
//                        Image(systemName: "person.crop.circle")
//                        Text("My Account")
//                    }
//                    .padding()
//                    .background(Color.themeOrange)
//                    .foregroundColor(.white)
//                    .cornerRadius(8)
//                }
//            }
//        }
//    }
//}
//
//struct IssueSection: View {
//    @State private var showingQRScanner = false
//    @State private var scannedData = [QRkData]()
//    @State private var showAlert = false
//    @State private var alertMessage = ""
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 30) {
//            Text("Issue Book ")
//                .font(.largeTitle)
//                .bold()
//
//            HStack(spacing: 20) {
//                IssueButton(title: "Scan QR", systemImageName: "qrcode.viewfinder", backgroundColor: Color.themeOrange) {
//                    self.showingQRScanner = true
//                }
//                .sheet(isPresented: $showingQRScanner) {
//                    QRScannerView { scannedCode in
//                        if let data = processQRCode(scannedCode) {
//                            scannedData.append(data)
//                            print("Scanned Data Array: \(scannedData)")
//                        } else {
//                            print("Failed to process QR code")
//                            self.alertMessage = "Invalid QR Code"
//                            self.showAlert = true
//                        }
//                        showingQRScanner = false
//                    }
//                }
//                .alert(isPresented: $showAlert) {
//                    Alert(title: Text("Validation Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
//                }
//            }
//
//            TableView(scannedData: scannedData)
//        }
//        .padding()
//        .frame(maxWidth: .infinity, alignment: .leading)
//    }
//}
//
//struct TableView: View {
//    let scannedData: [QRkData]
//
//    var body: some View {
//        VStack(alignment: .leading) {
//            HStack {
//                Text("User ID")
//                Spacer()
//                Text("ISBN")
//                Spacer()
//                Text("Issue Date")
//                Spacer()
//                Text("Issue Time")
//                Spacer()
//                Text("Return Date")
//                Spacer()
//                Text("Actions")
//            }
//            .font(.headline)
//            .padding(.horizontal)
//
//            // List of TableViewRow items
//            ScrollView {
//                VStack(spacing: 0) {
//                    ForEach(scannedData, id: \.isbn) { data in
//                        TableViewRow(record: data)
//                            .padding(.horizontal)
//                            .background(Color.white)
//                            .cornerRadius(8)
//                            .shadow(radius: 2)
//                            .padding(.vertical, 4)
//                    }
//                }
//            }
//            .background(Color(.systemGray6))
//            .cornerRadius(8)
//            .shadow(radius: 4)
//            .padding(.horizontal)
//        }
//        .padding(.top, 20)
//    }
//}
//
//struct TableViewRow: View {
//    var record: QRkData
//
//    var body: some View {
//        HStack {
//            Text(record.userId)
//                .padding(.vertical, 8)
//            Spacer()
//            Text(record.isbn)
//                .padding(.vertical, 8)
//            Spacer()
//            Text(record.date)
//                .padding(.vertical, 8)
//            Spacer()
//            Text(record.currentTime)
//                .padding(.vertical, 8)
//            Spacer()
//            Text(record.addDaysToDate())
//                .padding(.vertical, 8)
//            Spacer()
//            HStack {
//                // Action buttons can be added here
//                Button(action: {
//                    // Delete action
//                }) {
//                    Image(systemName: "trash")
//                        .foregroundColor(.red)
//                }
//                .padding(.vertical, 8)
//            }
//        }
//        .padding(.horizontal, 16)
//    }
//}
//
//// QR code scanning function
//func scanQRCodeFromImage(_ image: UIImage) -> String? {
//    guard let ciImage = CIImage(image: image) else { return nil }
//    let context = CIContext()
//    let options: [String: Any] = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
//    let qrDetector = CIDetector(ofType: CIDetectorTypeQRCode, context: context, options: options)
//    let features = qrDetector?.features(in: ciImage) as? [CIQRCodeFeature]
//    return features?.first?.messageString
//}
//
//// Process QR Code function
//func processQRCode(_ code: String) -> QRkData? {
//    print("Scanned Code: \(code)")
//    guard let jsonData = code.data(using: .utf8) else {
//        print("Failed to convert string to data")
//        return nil
//    }
//    let decoder = JSONDecoder()
//    do {
//        let scannedData = try decoder.decode(ScannedQRData.self, from: jsonData)
//        guard validateQRCode(scannedData: scannedData) else {
//            print("Invalid QR code")
//            return nil
//        }
//        let qrData = QRkData(
//            isbn: scannedData.isbn,
//            userId: scannedData.userId,
//            currentTime: scannedData.timestamp,
//            date: scannedData.date
//        )
//        print("Decoded QR Data: \(qrData)")
//        return qrData
//    } catch {
//        print("Failed to decode QR data: \(error)")
//        return nil
//    }
//}
//
//// QR Code validation function
//func validateQRCode(scannedData: ScannedQRData) -> Bool {
//    let dateFormatter = DateFormatter()
//    dateFormatter.dateFormat = "yyyy-MM-dd"
//    let currentDate = dateFormatter.string(from: Date())
//
//    guard scannedData.date == currentDate else {
//        print("QR code date does not match current date")
//        return false
//    }
//
//    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
//    guard let qrTime = dateFormatter.date(from: scannedData.timestamp) else {
//        print("Failed to parse QR code timestamp")
//        return false
//    }
//
//    let currentTime = Date()
//    let timeDifference = currentTime.timeIntervalSince(qrTime)
//    guard timeDifference <= 120 else {
//        print("QR code timestamp exceeds 2 minutes")
//        return false
//    }
//
//    return true
//}
//
//struct IssueButton: View {
//    let title: String
//    let systemImageName: String
//    let backgroundColor: Color
//    let action: () -> Void
//
//    var body: some View {
//        Button(action: action) {
//            VStack {
//                Image(systemName: systemImageName)
//                    .resizable()
//                    .frame(width: 100, height: 100)
//                    .foregroundColor(backgroundColor == .white ? .black : .white)
//
//                Text(title)
//                    .foregroundColor(backgroundColor == .white ? .black : .white)
//                    .font(.headline)
//            }
//            .padding()
//            .frame(width: 200, height: 200)
//            .background(backgroundColor)
//            .cornerRadius(12)
//        }
//    }
//}


///////////////////
///
///
///
///



import SwiftUI

struct Scanner: View {
    var body: some View {
        VStack {
            HeaderView()
            IssueSection()
        }
        .padding()
        .background(Color(.systemGray6))
    }
}

struct HeaderView: View {
    var body: some View {
        HStack {
            Spacer()
            HStack {
                Button(action: {}) {
                    Image(systemName: "bell")
                        .resizable()
                        .frame(width: 24, height: 24)
                }
                .padding()
                Button(action: {}) {
                    HStack {
                        Image(systemName: "person.crop.circle")
                        Text("My Account")
                    }
                    .padding()
                    .background(Color.themeOrange)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
            }
        }
    }
}

struct IssueSection: View {
    @State private var showingQRScanner = false
    @State private var scannedData = [QRkData]()
    @State private var showAlert = false
    @State private var alertMessage = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            Text("Issue Book")
                .font(.largeTitle)
                .bold()

            HStack(spacing: 20) {
                IssueButton(title: "Scan QR", systemImageName: "qrcode.viewfinder", backgroundColor: Color.themeOrange) {
                    self.showingQRScanner = true
                }
                .sheet(isPresented: $showingQRScanner) {
                    QRScannerView { scannedCode in
                        if let data = processQRCode(scannedCode) {
                            scannedData.insert(data, at: 0) // Add new data at the beginning
                            print("Scanned Data Array: \(scannedData)")
                        } else {
                            print("Failed to process QR code")
                            self.alertMessage = "Invalid QR Code"
                            self.showAlert = true
                        }
                        showingQRScanner = false
                    }
                }
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Validation Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
            }

            // Book table
            Table(scannedData) {
                TableColumn("Serial No") { data in
                    Text("\(scannedData.firstIndex(of: data)! + 1)")
                }
                TableColumn("User ID") { data in
                    Text(data.userId)
                }
                TableColumn("ISBN") { data in
                    Text(data.isbn)
                }
                TableColumn("Issue Date") { data in
                    Text(data.date)
                }
                TableColumn("Issue Time") { data in
                    Text(data.currentTime)
                }
                TableColumn("Return Date") { data in
                    Text(data.addDaysToDate())
                }
            }
            .cornerRadius(8)
            .padding(.horizontal)
            .padding(.top, 10)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// QR code scanning function
func scanQRCodeFromImage(_ image: UIImage) -> String? {
    guard let ciImage = CIImage(image: image) else { return nil }
    let context = CIContext()
    let options: [String: Any] = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
    let qrDetector = CIDetector(ofType: CIDetectorTypeQRCode, context: context, options: options)
    let features = qrDetector?.features(in: ciImage) as? [CIQRCodeFeature]
    return features?.first?.messageString
}

// Process QR Code function
func processQRCode(_ code: String) -> QRkData? {
    print("Scanned Code: \(code)")
    guard let jsonData = code.data(using: .utf8) else {
        print("Failed to convert string to data")
        return nil
    }
    let decoder = JSONDecoder()
    do {
        let scannedData = try decoder.decode(ScannedQRData.self, from: jsonData)
        guard validateQRCode(scannedData: scannedData) else {
            print("Invalid QR code")
            return nil
        }
        let qrData = QRkData(
            isbn: scannedData.isbn,
            userId: scannedData.userId,
            currentTime: scannedData.timestamp,
            date: scannedData.date
        )
        print("Decoded QR Data: \(qrData)")
        return qrData
    } catch {
        print("Failed to decode QR data: \(error)")
        return nil
    }
}

// QR Code validation function
func validateQRCode(scannedData: ScannedQRData) -> Bool {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    let currentDate = dateFormatter.string(from: Date())

    guard scannedData.date == currentDate else {
        print("QR code date does not match current date")
        return false
    }

    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    guard let qrTime = dateFormatter.date(from: scannedData.timestamp) else {
        print("Failed to parse QR code timestamp")
        return false
    }

    let currentTime = Date()
    let timeDifference = currentTime.timeIntervalSince(qrTime)
    guard timeDifference <= 120 else {
        print("QR code timestamp exceeds 2 minutes")
        return false
    }

    return true
}

struct IssueButton: View {
    let title: String
    let systemImageName: String
    let backgroundColor: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack {
                Image(systemName: systemImageName)
                    .resizable()
                    .frame(width: 100, height: 100)
                    .foregroundColor(backgroundColor == .white ? .black : .white)

                Text(title)
                    .foregroundColor(backgroundColor == .white ? .black : .white)
                    .font(.headline)
            }
            .padding()
            .frame(width: 200, height: 200)
            .background(backgroundColor)
            .cornerRadius(12)
        }
    }
}

// Models
struct QRkData: Codable, Identifiable, Equatable {
    var id: UUID = UUID()
    var isbn: String
    var userId: String
    var currentTime: String
    var date: String
    
    func addDaysToDate() -> String {
             let dateFormatter = DateFormatter()
             dateFormatter.dateFormat = "yyyy-MM-dd" // Adjust the date format to match your input string
    
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
}
