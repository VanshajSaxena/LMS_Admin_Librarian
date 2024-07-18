//
//  requests.swift
//  LMSAdminLibrarian
//
//  Created by Mahak garg on 17/07/24.
//
import Foundation
import FirebaseFirestore

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


import SwiftUI


struct AdminlView: View {
    @ObservedObject var viewModel = AdminViewModel()
    @State private var showingAddCampaignSheet = false
    @State private var processingCampaignId: String?
    
    var body: some View {
        VStack(alignment: .leading) {
            // Title
            Text("Pending Events and Campaigns")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.leading)
            
            // Add Campaign Button
            HStack {
                Spacer()
                Button(action: {
                    showingAddCampaignSheet.toggle()
                }) {
                    HStack {
                        Image(systemName: "plus")
                        Text("Add Campaigns")
                    }
                    .padding()
                    .background(Color.themeOrange)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .padding()
                .sheet(isPresented: $showingAddCampaignSheet) {
                    AddCampaignEventsSheetView(viewModel: AddCampaignEventsViewModel())
                }
            }
            
            // Campaign Cards and Placeholder
            if viewModel.campaigns.isEmpty {
                Text("No pending campaigns found.")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 20) {
                        ForEach(viewModel.campaigns) { campaign in
                            VStack(alignment: .leading) {
                                if campaign.type == "event" {
                                    campaignCard(for: campaign)
                                } else if campaign.type == "sale" {
                                    saleCampaignCard(for: campaign)
                                }
                                
                                if campaign.status == "pending" {
                                    HStack {
                                        Button(action: {
                                            if processingCampaignId != campaign.id {
                                                processingCampaignId = campaign.id
                                                viewModel.updateCampaignStatus(campaignId: campaign.id!, status: "approved") {
                                                    processingCampaignId = nil
                                                }
                                            }
                                        }) {
                                            Text("Approve")
                                                .padding()
                                                .background(Color.green)
                                                .foregroundColor(.white)
                                                .cornerRadius(10)
                                        }
                                        
                                        Button(action: {
                                            if processingCampaignId != campaign.id {
                                                processingCampaignId = campaign.id
                                                viewModel.updateCampaignStatus(campaignId: campaign.id!, status: "denied") {
                                                    processingCampaignId = nil
                                                }
                                            }
                                        }) {
                                            Text("Deny")
                                                .padding()
                                                .background(Color.red)
                                                .foregroundColor(.white)
                                                .cornerRadius(10)
                                        }
                                    }
                                    .padding(.top, 10)
                                } else {
                                    Text("Status: \(campaign.status.capitalized)")
                                        .font(.headline)
                                        .foregroundColor(campaign.status == "approved" ? .green : .red)
                                        .padding(.top, 10)
                                }
                            }
                        }
                    }
                    .padding(20)
                }
            }
            
            Spacer()
        }
        .task {
            await viewModel.fetchPendingCampaigns()
        }
    }
    
    // Campaign card for events
    func campaignCard(for campaign: CampaignsEvents) -> some View {
        VStack(alignment: .leading) {
            Image(campaign.imageName)
                .resizable()
                .scaledToFit()
                .frame(height: 100)
                .cornerRadius(10)
            
            Text(campaign.title)
                .font(.headline)
                .padding(.top, 8)
                .frame(alignment: .center)
            
            Text("\(campaign.startDate, formatter: dateFormatter) - \(campaign.endDate, formatter: dateFormatter)")
                .font(.subheadline)
                .frame(alignment: .center)
            
            Text(campaign.description)
                .font(.body)
        }
        .padding()
        .background(Color("CampaignCard"))
        .cornerRadius(10)
        .shadow(radius: 5)
    }
    
    // Sale campaign card
    func saleCampaignCard(for campaign: CampaignsEvents) -> some View {
        VStack(alignment: .leading) {
            HStack {
                Image(campaign.imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 150, height: 160)
                    .cornerRadius(10)
                    .clipped() // Ensure the image stays within the bounds
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(campaign.title)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.top, 8)
                        .frame(alignment: .center)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(campaign.price)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.orange)
                    }
                    
                    Text(campaign.description)
                        .font(.body)
                        .padding(.top, 8)
                    Text("*Terms and conditions apply")
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
                .padding(.horizontal)
            }
            .padding()
            .background(Color("CampaignCard"))
            .cornerRadius(10)
            .shadow(radius: 5)
            .frame(width: 375, height: 200)
        }
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }
}
