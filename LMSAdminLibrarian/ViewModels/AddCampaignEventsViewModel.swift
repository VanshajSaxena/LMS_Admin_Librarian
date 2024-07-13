//
//  AddCampaignViewModel.swift
//  LMSAdminLibrarian
//
//  Created by Vanshaj on 13/07/24.
//

import Foundation
import FirebaseFirestore

final class AddCampaignEventsViewModel: ObservableObject {
    private var db = Firestore.firestore()
    
    @Published var title: String = ""
    @Published var price: Double = 0.0
    @Published var startDate: Date = Date()
    @Published var endDate: Date = Date().addingTimeInterval(TimeInterval(60*60*24*7))
    @Published var description: String = ""
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        return formatter
    }
    
    func addCampaign() {
        let newCampaign = CampainsEvents(id: UUID().uuidString, title: title, price: price, startDate: startDate, endDate: endDate, description: description)
        let campaignDict: [String: String] = [
            "id": newCampaign.id,
            "title": newCampaign.title,
            "price": String(newCampaign.price),
            "startDate": dateFormatter.string(for: newCampaign.startDate) ?? "Cannot Conver Date Obj to String",
            "endDate": dateFormatter.string(for: newCampaign.endDate) ?? "Cannot Convert Date Obj to String",
            "description": newCampaign.description
        ]
        db.collection("campaigns").addDocument(data: campaignDict) { error in
            if let error = error {
                print("Error adding document: \(error)")
            } else {
                print("Document added with ID: \(newCampaign.id)")
            }
        }
        print("Campaign Added Successfully!")
    }
    static let sample: AddCampaignEventsViewModel = {
        let viewModel = AddCampaignEventsViewModel()
        viewModel.title = "Summer Sale"
        viewModel.price = 50
        viewModel.startDate = Date()
        viewModel.endDate = Date().addingTimeInterval(TimeInterval(60*60*24*7))
        viewModel.description = "Summer Sale"
        return viewModel
    }()
}
