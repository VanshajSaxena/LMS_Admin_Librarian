//
//  QRView.swift
//  LMSAdminLibrarian
//
//  Created by ttcomputer on 16/07/24.
//

import SwiftUI

struct Scanner: View {
    var body: some View {
        VStack {
            HeaderView()
            
            IssueSection()
            
           // RecordSection()

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
                Button(action: {}){
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
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
            }
        }
    }
}

struct IssueSection: View {
  
    @State private var showingImagePicker = false
    @State private var showingQRScanner = false
    @State private var scannedQRCode: String = ""
    @State private var scannedData = [QRkData]()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            Text("Issue")
                .font(.largeTitle)
                .bold()
            
            HStack(spacing: 20) {
                IssueButton(title: "Scan QR", systemImageName: "qrcode.viewfinder", backgroundColor: .orange) {
                    self.showingQRScanner = true
                }
                 .sheet(isPresented: $showingQRScanner) {
                    QRScannerView { scannedCode in
                        if let data = processQRCode(scannedCode) {
                            scannedData.append(data)
                            print("Scanned Data Array: \(scannedData)")
                        } else {
                            print("Failed to process QR code")
                        }
                        showingQRScanner = false
                    }
                }
                
                List(scannedData, id: \.isbn) { data in
                    VStack(alignment: .leading) {
                        Text("ISBN: \(data.isbn)")
                        Text("User ID: \(data.userId)")
                        Text("Time: \(data.currentTime)")
                        Text("Date: \(data.date)")
                    }
                }
              
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
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


//  QR code scanning function
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






struct TableViewRow: View {
    var record: Record

    var body: some View {
        HStack {
            Text(record.userId)
            Spacer()
            Text(record.isbnNumber)
            Spacer()
            Text(record.issueDate)
            Spacer()
            Text(record.issuedTime)
            Spacer()
            Text(record.returnDate)
            Spacer()
            HStack {
                Button(action: {
                    // Edit action
                }) {
                    Image(systemName: "pencil")
                        .foregroundColor(.black)
                }
                // Delete button
                Button(action: {
                    // Delete action
                }) {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                }
            }
        }
        .padding(.horizontal)
    }
}



