import SwiftUI
import Firebase
import PhotosUI

struct Scanner: View {
    @State private var showingQRScanner = false
    @State private var scannedData = [QRData]()
    
    var body: some View {
        VStack {
            HeaderView()
            IssueSection(showingQRScanner: $showingQRScanner, scannedData: $scannedData)
        }
        .padding()
        .background(Color(.systemGray6))
        .sheet(isPresented: $showingQRScanner) {
            QRScannerView { scannedCode in
                do {
                    if let data = processQRCode(scannedCode) {
                        if data.hasReturned {
                            returnBook(data: data)
                            let issuedCopies = try await decrementIssuedCopies(forBookISBN: data.isbn)
                            print("Decremented issued copies. New count: \(issuedCopies)")
                        } else {
                            issueBook(data: data)
                            let issuedCopies = try await incrementIssuedCopies(forBookISBN: data.isbn)
                            print("Incremented issued copies. New count: \(issuedCopies)")
                        }
                        scannedData.append(data)
                        print("Scanned Data Array: \(scannedData)")
                    } else {
                        print("Failed to process QR code")
                    }
                } catch {
                    print("Error processing QR code: \(error.localizedDescription)")
                }
                showingQRScanner = false
            }
        }
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
    @Binding var showingQRScanner: Bool

    @Binding var scannedData: [QRData]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            Text("Issue Book ")
                .font(.largeTitle)
                .bold()
            
            HStack(spacing: 20) {
                IssueButton(title: "Scan QR", systemImageName: "qrcode.viewfinder", backgroundColor: Color.themeOrange) {

                    self.showingQRScanner = true
                }
                .sheet(isPresented: $showingQRScanner) {
                    QRScannerView { scannedCode in
                            do {
                                if let data = processQRCode(scannedCode) {
                                    if data.hasReturned {
                                        returnBook(data: data)
                                        let issuedCopies = try await decrementIssuedCopies(forBookISBN: data.isbn)
                                        print("Decremented issued copies. New count: \(issuedCopies)")
                                    } else {
                                        issueBook(data: data)
                                        let issuedCopies = try await incrementIssuedCopies(forBookISBN: data.isbn)
                                        print("Incremented issued copies. New count: \(issuedCopies)")
                                    }
                                    scannedData.append(data)
                                    print("Scanned Data Array: \(scannedData)")
                                } else {
                                    print("Failed to process QR code")
                                }
                            } catch {
                                print("Error processing QR code: \(error.localizedDescription)")
                            }
                            showingQRScanner = false
                        }
                }
            }
            
            TableView(scannedData: scannedData)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct TableView: View {
    let scannedData: [QRData]

    var body: some View {
        VStack(alignment: .leading) {
            Table(scannedData) {
                TableColumn("User ID", value: \.userId)
                TableColumn("ISBN", value: \.isbn)
                TableColumn("Issue Date", value: \.date)
                TableColumn("Issue Time", value: \.currentTime)
                TableColumn("Return Date") { data in
                    Text(data.addDaysToDate())
                }
                TableColumn("Has Returned", value:  \.hasReturnedString)
            }
            .cornerRadius(8)
            .font(.headline)
            .padding(.horizontal)
            .padding(.horizontal)
            
        }
        .padding(.top, 20)
    }
}

struct TableViewRow: View {
    var record: QRData

    var body: some View {
        HStack {
            Text(record.userId)
                .padding(.vertical, 8)
            Spacer()
            Text(record.isbn)
                .padding(.vertical, 8)
            Spacer()
            Text(record.date)
                .padding(.vertical, 8)
            Spacer()
            Text(record.currentTime)
                .padding(.vertical, 8)
            Spacer()
            Text(record.addDaysToDate())
                .padding(.vertical, 8)
            
        }
        .padding(.horizontal, 16)
    }
}


//    private func calculateReturnDate(issueDate: Date) -> Date {
//        return Calendar.current.date(byAdding: .day, value: 30, to: issueDate) ?? issueDate
//    }

func issueBook(data: QRData) {
    let qrDataDict: [String: Any] = [
        "isbn": data.isbn,
        "issueDate": data.date,
        "dueDate": data.addDaysToDate(),
        "hasReturned": data.hasReturned
    ]
    
    let db = Firestore.firestore()
    
    let docRef: Void = db.collection("Users").document(data.userId).collection("History").document(data.isbn).setData(qrDataDict, merge: true) { error in
        if let error = error {
            print("Error adding document: \(error)")
        } else {
            print("Document added to user: \(data.userId)")
        }
    }
}

func returnBook(data: QRData) {
    let qrDataDict: [String: Any] = [
        "isbn": data.isbn,
        "returnDate": data.date,
        "hasReturned": data.hasReturned
    ]
    
    let db = Firestore.firestore()
    
    let docRef: Void = db.collection("Users").document(data.userId).collection("History").document(data.isbn).setData(qrDataDict, merge: true) { error in
        if let error = error {
            print("Error adding document: \(error)")
        } else {
            print("Document added to user: \(data.userId)")
        }
    }
}

func incrementIssuedCopies(forBookISBN isbn: String) async throws -> Int {
    let db = Firestore.firestore()
    let bookRef = db.collection("books").document(isbn)
    
    let result = try await db.runTransaction { (transaction, errorPointer) -> Int? in
        let bookDocument: DocumentSnapshot
        do {
            try bookDocument = transaction.getDocument(bookRef)
        } catch let fetchError as NSError {
            errorPointer?.pointee = fetchError
            return nil
        }
        
        guard let oldCount = bookDocument.data()?["numberOfIssuedCopies"] as? Int else {
            let error = NSError(domain: "AppErrorDomain", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unable to retrieve numberOfIssuedCopies"])
            errorPointer?.pointee = error
            return nil
        }
        
        let newCount = oldCount + 1
        transaction.updateData(["numberOfIssuedCopies": newCount], forDocument: bookRef)
        return newCount
    }
    
    guard let newCount = result else {
        throw NSError(domain: "AppErrorDomain", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to increment issued copies"])
    }
    
    return newCount as! Int
}

func decrementIssuedCopies(forBookISBN isbn: String) async throws -> Int {
    let db = Firestore.firestore()
    let bookRef = db.collection("books").document(isbn)
    
    let result = try await db.runTransaction { (transaction, errorPointer) -> Int? in
        let bookDocument: DocumentSnapshot
        do {
            try bookDocument = transaction.getDocument(bookRef)
        } catch let fetchError as NSError {
            errorPointer?.pointee = fetchError
            return nil
        }
        
        guard let oldCount = bookDocument.data()?["numberOfIssuedCopies"] as? Int else {
            let error = NSError(domain: "AppErrorDomain", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unable to retrieve numberOfIssuedCopies"])
            errorPointer?.pointee = error
            return nil
        }
        
        let newCount = max(0, oldCount - 1) // Ensure count doesn't go below 0
        transaction.updateData(["numberOfIssuedCopies": newCount], forDocument: bookRef)
        return newCount
    }
    
    guard let newCount = result else {
        throw NSError(domain: "AppErrorDomain", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to decrement issued copies"])
    }
    
    return newCount as! Int
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
func processQRCode(_ code: String) -> QRData? {
    print("Scanned Code: \(code)")
    guard let jsonData = code.data(using: .utf8) else {
        print("Failed to convert string to data")
        return nil
    }
    let decoder = JSONDecoder()
    do {
        let scannedData = try decoder.decode(ScannedQRData.self, from: jsonData)
        let qrData = QRData(
            isbn: scannedData.isbn,
            userId: scannedData.userId,
            currentTime: scannedData.timestamp,
            date: scannedData.date,
            hasReturned: scannedData.hasReturned
        )
        print("Decoded QR Data: \(qrData)")
        return qrData
    } catch {
        print("Failed to decode QR data: \(error)")
        return nil
    }
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
