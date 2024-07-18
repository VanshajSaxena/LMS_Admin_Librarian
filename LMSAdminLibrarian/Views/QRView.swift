


import SwiftUI
import Firebase

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
    @State private var scannedData = [QRData]()

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
                        if let data = processQRCode(scannedCode) {
                            issueBook(data: data)
                            scannedData.append(data)
                            print("Scanned Data Array: \(scannedData)")
                        } else {
                            print("Failed to process QR code")
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
            HStack {
                Text("User ID")
                Spacer()
                Text("ISBN")
                Spacer()
                Text("Issue Date")
                Spacer()
                Text("Issue Time")
                Spacer()
                Text("Return Date")
                Spacer()
                Text("Actions")
            }
            .font(.headline)
            .padding(.horizontal)

            // List of TableViewRow items
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(scannedData, id: \.isbn) { data in
                        TableViewRow(record: data)
                            .padding(.horizontal)
                            .background(Color.white)
                            .cornerRadius(8)
                            .shadow(radius: 2)
                            .padding(.vertical, 4)
                    }
                }
            }
            .background(Color(.systemGray6))
            .cornerRadius(8)
            .shadow(radius: 4)
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
            Spacer()
            HStack {
                // Action buttons can be added here
                Button(action: {
                    // Delete action
                }) {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                }
                .padding(.vertical, 8)
            }
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
    
    let docRef = db.collection("Users").document(data.userId).collection("History").addDocument(data: qrDataDict) {error in
        if let error = error {
            print("Error adding document: \(error)")
        } else {
            print("Document added to user: \(data.userId)")
        }
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
    let action: () -> Void // Add action closure

    var body: some View {
        Button(action: action) { // Use action closure in Button
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
