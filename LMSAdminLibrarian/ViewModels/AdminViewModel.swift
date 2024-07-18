//
//  AdminViewModel.swift
//  LMSAdminLibrarian
//
//  Created by Mahak garg on 18/07/24.
//

import SwiftUI
import Firebase
import Foundation

final class AdminViewModel: ObservableObject {
    private var db = Firestore.firestore()
    @Published var campaigns: [CampaignsEvents] = []
    
    init() {
        fetchPendingCampaigns()
    }
    
    func updateCampaignStatus(campaignId: String, status: String, completion: @escaping () -> Void) {
        db.collection("campaigns").document(campaignId).updateData([
            "status": status
        ]) { error in
            if let error = error {
                print("Error updating campaign status: \(error.localizedDescription)")
            } else {
                print("Campaign status updated successfully.")
            }
            completion()
        }
    }
    
    func fetchPendingCampaigns() {
        db.collection("campaigns").addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                print("Error fetching documents: \(error.localizedDescription)")
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                print("No documents found.")
                return
            }
            
            self.campaigns = documents.compactMap { queryDocumentSnapshot -> CampaignsEvents? in
                let data = queryDocumentSnapshot.data()
                let id = queryDocumentSnapshot.documentID
                let type = data["type"] as? String ?? ""
                let title = data["title"] as? String ?? ""
                let price = data["price"] as? String ?? ""
                let startDateString = data["startDate"] as? String ?? ""
                let endDateString = data["endDate"] as? String ?? ""
                let description = data["description"] as? String ?? ""
                let status = data["status"] as? String ?? ""
               
                
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd-MM-yyyy"
                let startDate = dateFormatter.date(from: startDateString) ?? Date()
                let endDate = dateFormatter.date(from: endDateString) ?? Date()
                
                return CampaignsEvents(id: id, type: type, title: title, price: price, startDate: startDate, endDate: endDate, description: description, status: status)
            }
        }
    }
}
