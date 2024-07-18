import Foundation
import FirebaseFirestore
import Combine
import SwiftUI


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
                .frame(width: 150, height: 160)
                .cornerRadius(10)
                .clipped() // Ensure the image stays within the bounds
                .padding(.leading, -20)
                .padding(.bottom, -50)
            
            VStack(alignment: .leading, spacing: 4) { // Reduced spacing
                GeometryReader { geometry in
                    Text(campaign.title)
                        .font(.system(size: 32, weight: .bold))
                        .lineLimit(1) // Ensure the title stays on one line
                        .foregroundColor(.orange)
                        .frame(width: geometry.size.width, alignment: .leading)
                }
                .frame(height: 40) // Fixed height to prevent layout issues

                Spacer().frame(height: 3) // Reduced spacing

                Text(campaign.price ?? "")
                    .font(.title2)// Slightly smaller font size for the price
                    .lineLimit(1)
                    .fontWeight(.bold)
                    .foregroundColor(.black)

                Spacer().frame(height: 7)
                Text(campaign.description)
                    .font(.body)
                    .foregroundColor(.gray)
                    .lineLimit(2) // Ensure the description fits into two lines

                Spacer().frame(height: 6)
                Text("\(campaign.startDate, formatter: dateFormatter) - \(campaign.endDate, formatter: dateFormatter)")
                    .font(.subheadline)
                    .frame(alignment: .center)

                Spacer().frame(height: 8)
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
#Preview{
    AddCampaignEventsView()
}
