import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

// Update CampaignType to conform to Codable

class CampaignEventsViewModel: ObservableObject {
    @Published var campaigns: [CampaignsEvents] = []
    
    private var db = Firestore.firestore()
    
    func fetchCampaigns() {
        db.collection("campaigns").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error fetching campaigns: \(error.localizedDescription)")
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            
            self.campaigns = documents.compactMap { queryDocumentSnapshot -> CampaignsEvents? in
                do {
                    let campaign = try queryDocumentSnapshot.data(as: CampaignsEvents.self)
                    print("Fetched campaign: \(campaign.title)")
                    return campaign
                } catch {
                    print("Error decoding campaign: \(error.localizedDescription)")
                    return nil
                }
            }
        }
    }
    func printFetchedCampaigns() {
           for campaign in campaigns {
               print("Campaign: \(campaign.title)")
               print("Type: \(campaign.type.rawValue)")
               // Add more properties as needed
           }
       }
    
}


struct AddCampaignEventsView: View {
    @State private var showingAddCampaignSheet = false
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass

    @StateObject private var viewModel = CampaignEventsViewModel()

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
                    .background(Color.orange)
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
                            if campaign.type == .event {
                                campaignCard(for: campaign)
                            } else if campaign.type == .sale {
                                saleCampaignCard(for: campaign)
                            }
                        }
                    }
                    .padding(20)
                }
            }

            Spacer()
        }
        .onAppear {
            viewModel.fetchCampaigns()
            viewModel.printFetchedCampaigns()
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
                .padding(.top, 8)
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

            VStack(alignment: .leading, spacing: 8) {
                Text(campaign.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 8)

                VStack(alignment: .leading, spacing: 4) {
                    Text(campaign.price)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.orange)
                }
                Text("*Terms and conditions apply")
                    .font(.footnote)
                    .foregroundColor(.gray)
                Text(campaign.description)
                    .font(.body)
                    .padding(.top, 8)
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


