



import SwiftUI
import FirebaseFirestore

final class CampaignViewModel: ObservableObject {
    @Published var campaigns: [Campaign] = []
    private var db = Firestore.firestore()

    init() {
        fetchCampaigns()
    }

    func addCampaign(type: Campaign.CampaignType, imageName: String, name: String, date: String, saleText: String? = nil) {
        let newCampaign = Campaign(type: type, imageName: imageName, name: name, date: date, saleText: saleText)
        campaigns.append(newCampaign)
    }

    func fetchCampaigns() {
        db.collection("campaigns").getDocuments { [weak self] (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                self?.campaigns = querySnapshot?.documents.compactMap { document -> Campaign? in
                    let data = document.data()
                    guard let typeString = data["type"] as? String,
                          let type = Campaign.CampaignType(rawValue: typeString),
                          let imageName = data["imageName"] as? String,
                          let name = data["name"] as? String,
                          let date = data["date"] as? String,
                          let saleText = data["saleText"] as? String? else {
                        return nil
                    }
                    return Campaign(type: type, imageName: imageName, name: name, date: date, saleText: saleText)
                } ?? []
            }
        }
    }
}


// Model to represent the campaign data
struct Campaign: Identifiable {
    enum CampaignType: String {
        case event
        case sale
    }

    let id = UUID()
    let type: CampaignType
    let imageName: String
    let name: String
    let date: String
    let saleText: String?
}


struct AddCampaignEventsView: View {
    @StateObject private var campaignViewModel = CampaignViewModel()
    @State private var showingAddCampaignSheet = false

    var body: some View {
        VStack(alignment: .leading) {
            Text("Events and Campaigns")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.leading)

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
                    .background(Color("ThemeOrange"))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .padding()
                .sheet(isPresented: $showingAddCampaignSheet) {
                    AddCampaignEventsSheetView(viewModel: AddCampaignEventsViewModel(campaignViewModel: campaignViewModel))
                }
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 30) {
                    ForEach(campaignViewModel.campaigns) { campaign in
                        if campaign.type == .event {
                            campaignCard(for: campaign)
                        } else if campaign.type == .sale {
                            saleCampaignCard(for: campaign)
                        }
                    }
                }
                .padding(20)
            }

            Spacer()
        }
    }

    func campaignCard(for campaign: Campaign) -> some View {
        VStack(alignment: .leading) {
            Image(campaign.imageName)
                .resizable()
                .scaledToFit()
                .frame(height: 100)
                .cornerRadius(10)
            Text(campaign.name)
                .font(.headline)
                .padding(.top, 8)
            Text(campaign.date)
                .font(.subheadline)
        }
        .padding()
        .background(Color("CampaignCard"))
        .cornerRadius(10)
        .shadow(radius: 5)
    }

    func saleCampaignCard(for campaign: Campaign) -> some View {
        HStack {
            Image(campaign.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 150, height: 160)
                .cornerRadius(10)

            VStack(alignment: .leading, spacing: 8) {
                Text(campaign.name)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 8)

                if let saleText = campaign.saleText {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(saleText.components(separatedBy: "\n")[0])
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.orange)

                        Text(saleText.components(separatedBy: "\n")[1])
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                    }
                }
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
