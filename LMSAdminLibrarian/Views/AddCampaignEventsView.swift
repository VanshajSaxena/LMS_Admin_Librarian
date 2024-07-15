import SwiftUI

// Model to represent the campaign data
struct Campaign: Identifiable {
    enum CampaignType {
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
    @State private var showingAddCampaignSheet = false
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    // Local array to hold campaign data
    var campaigns = [
        Campaign(type: .event, imageName: "books", name: "World Book Day", date: "23 April", saleText: nil),
        Campaign(type: .event, imageName: "books", name: "Ayush Sharma", date: "26 June", saleText: nil),
        Campaign(type: .sale, imageName: "Sales Card", name: "Sale!", date: "", saleText: "50% off\nAll fines"),
        // Add more campaigns here as needed
    ]
    
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
                    AddCampaignEventsSheetView(viewModel: AddCampaignEventsViewModel()) // Replace with your actual view
                }
            }
            
            // Campaign Cards and Placeholder
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 30) {
                    ForEach(campaigns) { campaign in
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
            Image(campaign.imageName) // Replace with your image name
                .resizable()
                .scaledToFit()
                .frame(height: 100)
                .cornerRadius(10)
            Text(campaign.name)
                .font(.headline)
                .padding(.top, 8)
                .frame(alignment: .center)
            Text(campaign.date)
                .font(.subheadline)
                .frame(alignment: .center)
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
                    // Display sale text in two lines with different styling
                    VStack(alignment: .leading, spacing: 4) {
                        Text(saleText.components(separatedBy: "\n")[0]) // First line of sale text
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.orange)
                        
                        Text(saleText.components(separatedBy: "\n")[1]) // Second line of sale text
                            .font(.headline) // Example of different font size
                            .fontWeight(.bold) // Example of different font weight
                            .foregroundColor(.black)// Example of different color
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AddCampaignEventsView()
                .previewDevice("iPad Pro (11-inch)")
            
            AddCampaignEventsView()
                .previewDevice("iPad Pro (12.9-inch) (5th generation)")
        }
    }
}
