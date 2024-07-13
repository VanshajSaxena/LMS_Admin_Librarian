import SwiftUI

struct AddCampaign: View {
    @State private var showingAddCampaignSheet = false
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
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
                    AddCampaignSheet() // Replace with your actual view
                }
            }
            
            // Campaign Card and Placeholder
            if horizontalSizeClass == .compact {
                VStack(spacing: 30) {
                    campaignCard
                    addCampaignPlaceholder
                }
                .padding(20)
            } else {
                HStack(spacing: 30) {
                    campaignCard
                    addCampaignPlaceholder
                }
                .padding(20)
            }
            
            Spacer()
        }
    }
    
    var campaignCard: some View {
        VStack(alignment: .leading) {
            Image("books") // Replace with your image name
                .resizable()
                .scaledToFit()
                .frame(height: 100)
                .cornerRadius(10)
            Text("World Book Day")
                .font(.headline)
                .padding(.top, 8)
            Text("23 April")
                .font(.subheadline)
        }
        .padding()
        .background(Color(UIColor.systemBackground))
        .cornerRadius(10)
        .shadow(radius: 5)
    }
    
    var addCampaignPlaceholder: some View {
        Button(action: {
            showingAddCampaignSheet.toggle()
        }) {
            RoundedRectangle(cornerRadius: 10)
                .strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [10]))
                .frame(width: 300, height: 190)
                .overlay(
                    Image(systemName: "plus")
                        .font(.largeTitle)
                        .foregroundColor(.orange)
                )
        }
        .sheet(isPresented: $showingAddCampaignSheet) {
            AddCampaignSheet() // Replace with your actual view
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AddCampaign()
                .previewDevice("iPad Pro (11-inch)")
            
            AddCampaign()
                .previewDevice("iPad Pro (12.9-inch) (5th generation)")
        }
    }
}
