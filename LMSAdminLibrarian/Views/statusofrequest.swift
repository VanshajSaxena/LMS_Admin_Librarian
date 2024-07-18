//
//  statusofrequest.swift
//  LMSAdminLibrarian
//
//  Created by Mahak garg on 17/07/24.
//

import SwiftUI

struct statusofrequest: View {
    @ObservedObject var viewModel = LibrarianViewModel()
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("My Requests")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.horizontal)
            
            if viewModel.requests.isEmpty {
                Text("No requests found.")
                    .foregroundColor(.white)
                    .padding()
            } else {
                List(viewModel.requests) { request in
                    RequestRow(request: request)
                        
                }
                .padding()
            }
            
            Spacer()
        }
        .onAppear {
            viewModel.fetchRequests()
        }
    }
}



struct RequestkRow: View {
    let request: CampaignsEvents
    @State private var isCampaignStopped = false
    
    var body: some View {
        VStack(alignment: .leading) {
            if request.type == "event" {
                campaignCard(for: request)
            } else if request.type == "sale" {
                saleCampaignCard(for: request)
            }
            
            Text("Status: \(request.status)")
                .foregroundColor(statusColor(for: request.status))
                .font(.subheadline)
                .padding(.top, 8)
            
            
        }
        .padding()
        .background(Color("RequestBackground"))
        .cornerRadius(10)
        .shadow(radius: 5)
    }
    
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
    
    func saleCampaignCard(for campaign: CampaignsEvents) -> some View {
        HStack {
            Image(campaign.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 150, height: 160)
                .cornerRadius(10)
                .clipped() // Ensure the image stays within the bounds
                .padding(.leading, -20)
                .padding(.bottom, -50)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(campaign.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 8)
                    .frame(alignment: .center)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(campaign.price ?? "")
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
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }
    private func statusColor(for status: String) -> Color {
        switch status {
        case "approved":
            return .green
        case "denied":
            return .red
        case "live":
            return .blue
        case "stopped":
            return .gray
        default:
            return .gray
        }
    }

}
