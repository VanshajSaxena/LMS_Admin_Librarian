import Foundation
import FirebaseFirestore

final class AddCampaignEventsViewModel: ObservableObject {
    private var db = Firestore.firestore()
    @Published var title: String = ""
    @Published var price: String = ""
    @Published var startDate: Date = Date()
    @Published var endDate: Date = Date().addingTimeInterval(TimeInterval(60*60*24*7))
    @Published var description: String = ""
    @Published var type: CampaignsEvents.CampaignType = .event // Add this line
    
    //
    //    var campaignViewModel: CampaignViewModel
    //
    //    init(campaignViewModel: CampaignViewModel) {
    //        self.campaignViewModel = campaignViewModel
    //    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        return formatter
    }
    
    func addCampaign() {
        // Assuming `type` is a parameter or defined elsewhere in your scope
         // Example type, change as needed
        
        let newCampaign = CampaignsEvents(
            id: UUID().uuidString,
            type: type,
            title: title,
            price: price,
            startDate: startDate,
            endDate: endDate,
            description: description
        )
        
        let campaignDict: [String: Any] = [
            "id": newCampaign.id,
            "title": newCampaign.title,
            "price": newCampaign.price,
            "startDate": dateFormatter.string(for: newCampaign.startDate) ?? "Cannot Convert Date Obj to String",
            "endDate": dateFormatter.string(for: newCampaign.endDate) ?? "Cannot Convert Date Obj to String",
            "description": newCampaign.description,
            "type": type == .event ? "event" : "sale"
        ]
        
        // Add to Firestore
        db.collection("campaigns").addDocument(data: campaignDict) { error in
            if let error = error {
                print("Error adding document: \(error)")
            } else {
                print("Document added with ID: \(newCampaign.id)")
            }
        }
        
        // Add to local view model
        let formattedDate = dateFormatter.string(from: startDate)
        // Assuming `campaignViewModel` and `addCampaign` are defined and available in your scope
        // campaignViewModel.addCampaign(type: type, imageName: newCampaign.imageName, name: title, date: formattedDate)
        
        print("Campaign Added Successfully!")
    }
}
