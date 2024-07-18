import Foundation
import FirebaseFirestore

final class AddCampaignEventsViewModel: ObservableObject {
    private var db = Firestore.firestore()
    @Published var title: String = ""
    @Published var price: String = ""
    @Published var startDate: Date = Date()
    @Published var endDate: Date = Date().addingTimeInterval(TimeInterval(60*60*24*7))
    @Published var description: String = ""
    @Published var type: String = "event" // Default to "event" if no type is set
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        return formatter
    }
    
    func addCampaign() {
        let newCampaign = CampaignsEvents(
            id: UUID().uuidString,
            type: type == "event" ? "event" : "sale",
            title: title,
            price: price,
            startDate: startDate,
            endDate: endDate,
            description: description,
            status: "pending" // Set initial status to pending
        )
        
        let campaignDict: [String: Any] = [
            "id": newCampaign.id ?? "",
            "title": newCampaign.title,
            "price": newCampaign.price,
            "startDate": dateFormatter.string(from: newCampaign.startDate),
            "endDate": dateFormatter.string(from: newCampaign.endDate),
            "description": newCampaign.description,
            "type": newCampaign.type,
            "status": newCampaign.status // Include status in the dictionary
        ]
        
        // Add to Firestore
        db.collection("campaigns").addDocument(data: campaignDict) { error in
            if let error = error {
                print("Error adding document: \(error)")
            } else {
                print("Document added with ID: \(newCampaign.id ?? "")")
            }
        }
        
        // Reset fields after adding campaign
        title = ""
        price = ""
        startDate = Date()
        endDate = Date().addingTimeInterval(TimeInterval(60*60*24*7))
        description = ""
        type = "event" // Reset type to "event"
        
        print("Campaign Added Successfully!")
    }
}

