import Foundation
import FirebaseFirestore

final class AddCampaignEventsViewModel: ObservableObject {
    private var db = Firestore.firestore()
    @Published var title: String = ""
    @Published var price: Double = 0.0
    @Published var startDate: Date = Date()
    @Published var endDate: Date = Date().addingTimeInterval(TimeInterval(60*60*24*7))
    @Published var description: String = ""
    
    var campaignViewModel: CampaignViewModel
    
    init(campaignViewModel: CampaignViewModel) {
        self.campaignViewModel = campaignViewModel
    }

    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        return formatter
    }
    
    func addCampaign() {
        let newCampaign = CampaignsEvents(id: UUID().uuidString, title: title, price: price, startDate: startDate, endDate: endDate, description: description)
        let campaignDict: [String: Any] = [
            "id": newCampaign.id,
            "title": newCampaign.title,
            "price": String(newCampaign.price),
            "startDate": dateFormatter.string(for: newCampaign.startDate) ?? "Cannot Convert Date Obj to String",
            "endDate": dateFormatter.string(for: newCampaign.endDate) ?? "Cannot Convert Date Obj to String",
            "description": newCampaign.description,
            "type": "event",
            "imageName": "books",
            "date": dateFormatter.string(from: startDate)
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
        campaignViewModel.addCampaign(type: .event, imageName: "books", name: title, date: formattedDate)
        
        print("Campaign Added Successfully!")
    }

}
