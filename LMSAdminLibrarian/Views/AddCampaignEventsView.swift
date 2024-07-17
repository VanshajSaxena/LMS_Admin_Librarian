import Foundation
import FirebaseFirestore
import Combine
import SwiftUI

final class CampaignsEventsViewModel: ObservableObject {
    private var db = Firestore.firestore()
    @Published var campaigns: [CampaignsEvents] = []

    func fetchCampaigns() {
        db.collection("campaigns").addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                print("Error fetching documents: \(error)")
                return
            }

            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }

            self.campaigns = documents.compactMap { queryDocumentSnapshot -> CampaignsEvents? in
                let data = queryDocumentSnapshot.data()
                let id = data["id"] as? String ?? ""
                let type = data["type"] as? String ?? ""
                let title = data["title"] as? String ?? ""
                let price = data["price"] as? String ?? ""
                let startDateString = data["startDate"] as? String ?? ""
                let endDateString = data["endDate"] as? String ?? ""
                let description = data["description"] as? String ?? ""

                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd-MM-yyyy"
                let startDate = dateFormatter.date(from: startDateString) ?? Date()
                let endDate = dateFormatter.date(from: endDateString) ?? Date()

                return CampaignsEvents(id: id, type: type, title: title, price: price, startDate: startDate, endDate: endDate, description: description)
            }
        }
    }
}
struct AddCampaignEventsView: View {
    @State private var showingAddCampaignSheet = false
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    @StateObject private var viewModel = CampaignsEventsViewModel()
    
    var body: some View {
        VStack(alignment: .leading) {
            // Title
            Text("Events and Campaigns")
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
                Text("No campaigns found.")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 30) {
                        ForEach(viewModel.campaigns) { campaign in
                            if campaign.type == "event" {
                                campaignCard(for: campaign)
                            } else if campaign.type == "sale" {
                                saleCampaignCard(for: campaign)
                            }
                        }
                    }
                    .padding(20)
                }
            }
            
            Spacer()
        }
        .task {
            await viewModel.fetchCampaigns()
        }
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
            .padding(.bottom , -50)
            
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
}


