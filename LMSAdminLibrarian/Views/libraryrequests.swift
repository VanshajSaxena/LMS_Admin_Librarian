import Foundation
import FirebaseFirestore
import SwiftUI



struct LibrarianRequestsView: View {
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



struct RequestRow: View {
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
            
            buttonView(for: request)
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
    
    @ViewBuilder
    private func buttonView(for request: CampaignsEvents) -> some View {
        switch request.status {
        case "approved":
            Button(action: {
                makeCampaignLive(for: request)
            }) {
                Text("Make Live")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.top, 8)
        case "live":
            Button(action: {
                stopCampaign(for: request)
            }) {
                Text(isCampaignStopped ? "Campaign Stopped" : "Stop Campaign")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(isCampaignStopped ? Color.gray : Color.red)
                    .cornerRadius(10)
            }
            .padding(.top, 8)
            .disabled(isCampaignStopped)
        case "denied":
            Button(action: {}) {
                Text("Request Denied")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.gray)
                    .cornerRadius(10)
            }
            .padding(.top, 8)
            .disabled(true)
            
        case "stopped":
            Button(action: {}) {
                Text("Campaign Stopped")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.gray)
                    .cornerRadius(10)
            }
            .padding(.top, 8)
            .disabled(true)
            
        default:
            EmptyView()
        }
    }
    
    private func makeCampaignLive(for campaign: CampaignsEvents) {
        let db = Firestore.firestore()
        guard let documentId = campaign.id else { return }
        
        db.collection("campaigns").document(documentId).updateData([
            "status": "live"
        ]) { error in
            if let error = error {
                print("Error updating document: \(error)")
            } else {
                print("Document successfully updated to live status")
            }
        }
    }
    
    private func stopCampaign(for campaign: CampaignsEvents) {
        let db = Firestore.firestore()
        guard let documentId = campaign.id else { return }
        
        db.collection("campaigns").document(documentId).updateData([
            "status": "stopped"
        ]) { error in
            if let error = error {
                print("Error updating document: \(error)")
            } else {
                print("Document successfully updated to stopped status")
                isCampaignStopped = true // Set the state variable to true
            }
        }
    }
}
