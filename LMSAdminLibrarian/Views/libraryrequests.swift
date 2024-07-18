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
            HStack(alignment: .top, spacing: 10){
                HStack {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .foregroundColor(Color("ThemeOrange"))
                        .padding(.trailing, 20)
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Rohit Singh")
                            .font(.headline)
                            .fontWeight(.bold)
                        Text("requested to organize a new campaign for the month of December")
                            .font(.headline)
                            .foregroundColor(.gray)
                    }
                }
                .padding(.leading)
                Spacer()
                Text("Status: \(request.status)")
                    .foregroundColor(statusColor(for: request.status))
                    .font(.title2)
                    .padding(.top, 5)
            }

            
            
            if request.type == "event" {
                campaignCard(for: request)
            } else if request.type == "sale" {
                saleCampaignCard(for: request)
            }
            buttonView(for: request)
        }
        .padding()
        .background(Color("RequestBackground"))
        .cornerRadius(10)

    }
    
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
    
    private func statusColor(for status: String) -> Color {
        switch status {
        case "approved":
            return .green
        case "denied":
            return .red
        case "live":
            return .themeOrange
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
                    .frame(width: 200)
                    .background(Color.themeOrange)
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
                    .frame(width: 200)
                    .background(isCampaignStopped ? Color.gray : Color.red)
                    .cornerRadius(10)
            }
            .padding(.top, 18)
            .padding(.leading, 90)
            .disabled(isCampaignStopped)
        case "denied":
            Button(action: {}) {
                Text("Request Denied")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 200)
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
                    .frame(width: 200)
                    .background(Color.gray)
                    .cornerRadius(10)
            }
            .padding(.top, 18)
            .padding(.leading, 80)
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
struct LibrarianRequestsViewPreviews: PreviewProvider {
    static var previews: some View {
        LibrarianRequestsView()
            .previewDevice(PreviewDevice(rawValue: "iPad Pro (11-inch)"))
            .previewDisplayName("iPad Pro 11-inch")
    }
}
