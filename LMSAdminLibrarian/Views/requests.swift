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
    @State private var selectedButton: String? = nil // Add a state variable to track the selected button
      
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
                                                    selectedButton = "approved_\(campaign.id!)"
                                                }
                                            }
                                        }) {
                                            Text("Approve")
                                                .padding()
                                                .frame(minWidth: 100) // Set minimum width for consistency
                                                .background(selectedButton == "approved_\(campaign.id!)" ? Color("ThemeOrange") : Color.clear)
                                                .foregroundColor(selectedButton == "approved_\(campaign.id!)" ? .white : .themeOrange)
                                                .cornerRadius(10)
                                              
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 12)
                                                        .stroke(Color("ThemeOrange")))
                                        }
                                        .padding(.leading , 55)

                                        Button(action: {
                                            if processingCampaignId != campaign.id {
                                                processingCampaignId = campaign.id
                                                viewModel.updateCampaignStatus(campaignId: campaign.id!, status: "denied") {
                                                    processingCampaignId = nil
                                                    selectedButton = "denied_\(campaign.id!)" // Set the selected button
                                                }
                                            }
                                        }) {
                                            Text("Deny")
                                                .padding()
                                                .frame(minWidth: 100) // Set minimum width for consistency
                                                .background(selectedButton == "denied_\(campaign.id!)" ? Color("ThemeOrange") : Color.clear)
                                                .foregroundColor(selectedButton == "denied_\(campaign.id!)" ? .white : .themeOrange)
                                                .cornerRadius(10)
                                               
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 10)
                                                        .stroke(Color("ThemeOrange")))
                                        }
                                    }
                                    .padding(.top, 10)
                                } else {
                                    Text("Status: \(campaign.status.capitalized)")
                                        .font(.headline)
                                        .foregroundColor(campaign.status == "approved" ? .green : .red)
                                        .padding(.top, 10)
                                        .padding(.leading,55)
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
        VStack {
            Image(campaign.imageName)
                .resizable()
                .scaledToFit()
                .frame(height: 100)
                .cornerRadius(10)
            
            Spacer().frame(height: 5)
            
            Text(campaign.title)
                .font(.system(size: 28, weight: .bold))
                .multilineTextAlignment(.center)
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .center)
                .foregroundColor(.orange)
                .padding(.top)
            
            Spacer().frame(height: 9) // Add space between the title and date
            
            Text("\(campaign.startDate, formatter: dateFormatter) - \(campaign.endDate, formatter: dateFormatter)")
                .font(.subheadline)
                .frame(alignment: .center)
            
            Spacer().frame(height: 8) // Add space between the date and description
            
            Text(campaign.description)
                .font(.body)
                .foregroundColor(.gray)
//            Text("*Terms and conditions apply")
//                .font(.footnote)
//                .foregroundColor(.gray)
        }
        .padding()
        .background(Color("CampaignCard"))
        .cornerRadius(10)
        .shadow(radius: 5)
    }

    // Sale campaign card
    func saleCampaignCard(for campaign: CampaignsEvents) -> some View {
        HStack {
            Image(campaign.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 130, height: 200)
                .cornerRadius(10)
                .clipped() // Ensure the image stays within the bounds
                .padding(.leading, -10)
                .padding(.bottom, -50)
            
            VStack(alignment: .center, spacing: 4) { // Reduced spacing
                Text(campaign.title)
                    .font(.title) // Slightly smaller font size for the title
                    .lineLimit(1)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                Spacer().frame(height: 7) // Reduced spacing
                GeometryReader { geometry in
                    Text(campaign.price ?? "")
                        .font(.system(size: 40, weight: .bold)) // Set the font size and weight for the price
                        .lineLimit(1) // Ensure the price stays on one line
                        .foregroundColor(.orange)
                        .frame(width: geometry.size.width, alignment: .center)
                }
                .frame(height: 40) // Fixed height to prevent layout issues

                Spacer().frame(height: 10)
                Text(campaign.description)
                    .font(.body)
                    .foregroundColor(.black)
                    .lineLimit(1) // Ensure the description fits into one line
                    .font(.system(size: 32))
                
                Spacer().frame(height: 12)
                Text("\(campaign.startDate, formatter: dateFormatter) - \(campaign.endDate, formatter: dateFormatter)")
                    .font(.title3)
                    .frame(alignment: .center)
                
                Spacer().frame(height: 12)
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
        .frame(width: 375, height: 300)
    }

    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }
}

struct AdminRequestViewPreviews: PreviewProvider {
    static var previews: some View {
        AdminRequestView()
            .previewDevice(PreviewDevice(rawValue: "iPad Pro (11-inch)"))
            .previewDisplayName("iPad Pro 11-inch")
    }
}
