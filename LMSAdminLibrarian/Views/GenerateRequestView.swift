//
//  GenerateRequestView.swift
//  LMSAdminLibrarian
//
//  Created by Mahak garg on 15/07/24.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine

struct User: Identifiable {
    var id: String
    var email: String
    var role: String // "librarian" or "admin"
}

struct Request: Identifiable, Codable {
    var id: String
    var title: String
    var details: String
    var status: String // "pending", "approved", or "denied"
    var librarianId: String
}

class RequestRepository: ObservableObject {
    private let db = Firestore.firestore()
    @Published var requests = [Request]()
    
    func addRequest(_ request: Request) {
        do {
            try db.collection("requests").document(request.id).setData(from: request)
            print("Document added with ID: \(request.id)")
        } catch {
            print("Error adding request: \(error)")
        }
    }
    
    func listenToRequests() {
        db.collection("requests").addSnapshotListener { querySnapshot, error in
            if let querySnapshot = querySnapshot {
                self.requests = querySnapshot.documents.compactMap { document in
                    try? document.data(as: Request.self)
                }
            }
        }
    }
    
    func updateRequestStatus(id: String, status: String, completion: @escaping () -> Void) {
        db.collection("requests").document(id).updateData(["status": status]) { error in
            if let error = error {
                print("Error updating request: \(error)")
            } else {
                print("Successfully updated request status to \(status) for request ID \(id)")
            }
            completion()
        }
    }
}

struct LibrariankView: View {
    @State private var requestTitle = ""
    @State private var requestDetails = ""
    @ObservedObject var requestRepo = RequestRepository()
    
    var isFormValid: Bool {
        !requestTitle.isEmpty && !requestDetails.isEmpty
    }
    
    var body: some View {
        VStack {
            Text("Generate Request")
                .font(.title)
                .fontWeight(.bold)
                .padding()
                .foregroundColor(.black)
                .padding(.leading)
            
            TextField("Request Title", text: $requestTitle)
                
                .padding([.leading, .trailing], 50)
                .padding(.top, 20)
                .frame(height: 50)
                .background(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color("ThemeOrange"), lineWidth: 1)
                        .padding([.leading, .trailing], 40)
                )
                .padding(.bottom,20)
            
            TextField("Request Details", text: $requestDetails)
                .padding([.leading, .trailing], 50)
                .padding(.top, 20)
                .frame(height: 50)
                .background(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color("ThemeOrange"), lineWidth: 1)
                        .padding([.leading, .trailing], 40)
                )
                .padding(.bottom,20)
            
            Button(action: {
                let newRequest = Request(id: UUID().uuidString, title: requestTitle, details: requestDetails, status: "pending", librarianId: "librarian_id")
                requestRepo.addRequest(newRequest)
                requestTitle = ""
                requestDetails = ""
            }) {
                Text("Send Request")
                    .padding()
                    .foregroundColor(.white)
                    .background(isFormValid ? Color("ThemeOrange") : Color.gray)
                    .cornerRadius(8)
            }
            .disabled(!isFormValid)
            
            List(requestRepo.requests) { request in
                Text("\(request.title): \(request.status)")
            }
            .padding(.top, 20)
        }
        
        .onAppear {
            requestRepo.listenToRequests()
        }
    }
}

struct AdminkView: View {
    @ObservedObject var requestRepo = RequestRepository()
    @State private var processingRequestId: String?
    
    var body: some View {
        List(requestRepo.requests) { request in
            HStack {
                Text(request.title)
                Spacer()
                
                Button(action: {
                    if processingRequestId != request.id {
                        processingRequestId = request.id
                        requestRepo.updateRequestStatus(id: request.id, status: "approved") {
                            processingRequestId = nil
                        }
                    }
                }) {
                    Text("Approve")
                        .padding()
                        .background(Color("Green")) // Green background color
                        .foregroundColor(.white) // White text color
                        .cornerRadius(12) // Rounded corners
                }
                .buttonStyle(BorderlessButtonStyle())
                
                Button(action: {
                    if processingRequestId != request.id {
                        processingRequestId = request.id
                        requestRepo.updateRequestStatus(id: request.id, status: "denied") {
                            processingRequestId = nil
                        }
                    }
                }) {
                    Text("Deny")
                        .padding()
                        .background(Color("Red")) // Red background color
                        .foregroundColor(.white) // White text color
                        .cornerRadius(12) // Rounded corners
                        .opacity(processingRequestId == request.id ? 0.5 : 1) // Adjust opacity when disabled
                        .disabled(processingRequestId == request.id)
                }
                .buttonStyle(BorderlessButtonStyle())
            }
        }
        .onAppear {
            requestRepo.listenToRequests()
        }
    }
}
