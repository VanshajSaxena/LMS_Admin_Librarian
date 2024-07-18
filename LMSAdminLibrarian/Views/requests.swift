//
//  requests.swift
//  LMSAdminLibrarian
//
//  Created by Mahak garg on 17/07/24.
//
import Foundation
import FirebaseFirestore



import SwiftUI


struct AdminRequestView: View {
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
                .padding(.top)
            
            Divider()
                .padding(.horizontal)
            
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
                                
                                HStack(alignment: .top, spacing: 10) {
                                    Image(systemName: "person.circle.fill")
                                        .resizable()
                                        .frame(width: 50, height: 50)
                                        .foregroundColor(Color("ThemeOrange"))
                                    
                                    VStack(alignment: .leading, spacing: 5) {
                                        Text("Rohit Singh")
                                            .font(.headline)
                                            .fontWeight(.bold)
                                        Text("requested to organize a new campaign for the month of December")
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                    }
                                }
                                .padding(.bottom, 15)
                                
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
                            .padding(.horizontal)
                            Divider()
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
            
            Text("\(campaign.startDate, formatter: dateFormatter) - \(campaign.endDate, formatter: dateFormatter)")
                .font(.subheadline)
            
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
