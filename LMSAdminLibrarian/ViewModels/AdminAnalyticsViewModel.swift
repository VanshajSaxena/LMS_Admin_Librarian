//
//  AdminAnalyticsViewModel.swift
//  LMSAdminLibrarian
//
//  Created by Vanshaj on 16/07/24.
//

import Foundation
import FirebaseFirestore

final class AdminAnalyticsViewModel: ObservableObject {
    @Published var analyticsData: [AnalyticsData] = []
    private let db = Firestore.firestore()
    
    func fetchTotalNumberOfUsers() async -> Int? {
        let usersCollection = db.collection("Users")
        do {
            let snapShot = try await usersCollection.getDocuments()
            return snapShot.documents.count
        } catch {
            print("failed to fetch total number of users: \(error)")
            return nil
        }
    }
    
    func fetchTotalNumberOfBooks() async -> Int? {
        let booksCollection = db.collection("books")
        
        do {
            let snapShot = try await booksCollection.getDocuments()
            return snapShot.documents.count
        } catch {
            print("failed to fetch total number of books in library: \(error)")
            return nil
        }
    }
    
    
    func createAnalyticsDataObj() async -> [AnalyticsData]? {
        await withTaskGroup(of: (Int?, Int?).self, returning: [AnalyticsData]?.self) { group in
            group.addTask { (await self.fetchTotalNumberOfBooks(), await self.fetchTotalNumberOfUsers()) }
            
            guard let (numberOfTotalBooks, numberOfTotalUsers) = await group.next() else {
                return nil
            }
            
            guard let numberOfTotalBooks = numberOfTotalBooks, let numberOfTotalUsers = numberOfTotalUsers else {
                return nil
            }
            
            let numberOfTotalBooksData = AnalyticsData(
                image: "book.circle.fill",
                amount: "\(numberOfTotalBooks)",
                title: "Total Books",
                rate: "up 30%"
            )
            
            let numberOfTotalUsersData = AnalyticsData(
                image: "person.circle.fill",
                amount: "\(numberOfTotalUsers)",
                title: "Total Users",
                rate: "up 30%"
            )
            
            return [numberOfTotalBooksData, numberOfTotalUsersData]
        }
    }
    
    func updateUIwithChanges() async {
        if let data = await createAnalyticsDataObj() {
            await MainActor.run {
                self.analyticsData += data
                print("updated published analyticsData variable with data: \(data)")
            }
        }
    }
}
