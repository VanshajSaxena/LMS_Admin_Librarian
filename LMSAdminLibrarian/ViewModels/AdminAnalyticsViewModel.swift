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
    
    
    func createAnalyticsDataObj() async -> (basicStats: [AnalyticsData], issueReturnsData: [(month: String, issued: Int, returned: Int)], genreData: ([(genre: String, percentage: Double)], Int))? {
        await withTaskGroup(of: (Int?, Int?, [(String, Int, Int)]?, ([(String, Double)], Int)?).self, returning: (basicStats: [AnalyticsData], issueReturnsData: [(month: String, issued: Int, returned: Int)], genreData: ([(genre: String, percentage: Double)], Int))?.self) { group in
            group.addTask {
                (
                    await self.fetchTotalNumberOfBooks(),
                    await self.fetchTotalNumberOfUsers(),
                    await self.fetchWeeklyIssueAndReturnsData(for: 6),
                    await self.fetchGenreData()
                )
            }
            
            guard let (totalBooks, totalUsers, issueReturnsData, genreData) = await group.next() else { return nil }
            
            guard let totalBooks = totalBooks, let totalUsers = totalUsers,
                  let issueReturnsData = issueReturnsData, let genreData = genreData else {
                return nil
            }
            
            let basicStats = [
                AnalyticsData(image: "book.circle.fill", amount: "\(totalBooks)", title: "Total Books", rate: "N/A"),
                AnalyticsData(image: "person.circle.fill", amount: "\(totalUsers)", title: "Total Users", rate: "N/A")
            ]
            
            return (basicStats: basicStats, issueReturnsData: issueReturnsData, genreData: genreData)
        }
    }
    
    func updateUIwithChanges() async {
        if let data = await createAnalyticsDataObj() {
            await MainActor.run {
                self.analyticsData.append(contentsOf: data.basicStats)
                print("Data for Analytics View: \(data)")
            }
        }
    }
    
    func fetchWeeklyIssueAndReturnsData(for weeks: Int) async -> [(week: String, issued: Int, returned: Int)] {
        let usersCollection = db.collection("Users")
        let endDate = Date()
        let startDate = Calendar.current.date(byAdding: .weekOfYear, value: -weeks, to: endDate)!
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let startDateString = dateFormatter.string(from: startDate)
        let endDateString = dateFormatter.string(from: endDate)
        
        do {
            // First, get all user documents
            let userSnapshot = try await usersCollection.getDocuments()
            
            var weeklyData: [Date: (issued: Int, returned: Int)] = [:]
            let calendar = Calendar.current
            
            // Iterate through each user
            for userDoc in userSnapshot.documents {
                // Access the History collection for this user
                let historyCollection = userDoc.reference.collection("History")
                let historySnapshot = try await historyCollection
                    .whereField("issueDate", isGreaterThanOrEqualTo: startDateString)
                    .whereField("issueDate", isLessThanOrEqualTo: endDateString)
                    .getDocuments()
                
                // Process each document in the History collection
                for historyDoc in historySnapshot.documents {
                    guard let issueDateString = historyDoc.data()["issueDate"] as? String,
                          let issueDate = dateFormatter.date(from: issueDateString),
                          let dueDateString = historyDoc.data()["dueDate"] as? String,
                          let dueDate = dateFormatter.date(from: dueDateString) else {
                        continue
                    }
                    
                    // Get the start of the week for the issue date
                    let weekStart = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: issueDate))!
                    
                    // Increment issued count
                    weeklyData[weekStart, default: (0, 0)].issued += 1
                    
                    // Check if the book has been returned (assuming it's returned if the current date is past the due date)
                    if Date() > dueDate {
                        weeklyData[weekStart, default: (0, 0)].returned += 1
                    }
                }
            }
            
            // Format the data for return
            let weekFormatter = DateFormatter()
            weekFormatter.dateFormat = "MMM d"
            
            return weeklyData.map { (week: weekFormatter.string(from: $0.key), issued: $0.value.issued, returned: $0.value.returned) }
                .sorted { weekFormatter.date(from: $0.week)! < weekFormatter.date(from: $1.week)! }
        } catch {
            print("Failed to fetch weekly issue and returns data: \(error)")
            return []
        }
    }
    
    func fetchIssueAndReturnsData(for months: Int) async -> [(month: String, issued: Int, returned: Int)] {
        let checkoutsCollection = db.collection("Checkouts")
        let endDate = Date()
        let startDate = Calendar.current.date(byAdding: .month, value: -months, to: endDate)!
        
        do {
            let snapshot = try await checkoutsCollection
                .whereField("checkoutDate", isGreaterThan: startDate)
                .whereField("checkoutDate", isLessThanOrEqualTo: endDate)
                .getDocuments()
            
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM"
            
            var monthlyData: [String: (issued: Int, returned: Int)] = [:]
            
            for doc in snapshot.documents {
                guard let checkoutDate = (doc.data()["checkoutDate"] as? Timestamp)?.dateValue(),
                      let returnDate = (doc.data()["returnDate"] as? Timestamp)?.dateValue() else {
                    continue
                }
                
                let monthStr = formatter.string(from: checkoutDate)
                monthlyData[monthStr, default: (0, 0)].issued += 1
                
                if returnDate <= endDate {
                    monthlyData[monthStr, default: (0, 0)].returned += 1
                }
            }
            
            return monthlyData.map { (month: $0.key, issued: $0.value.issued, returned: $0.value.returned) }
                .sorted { formatter.date(from: $0.month)! < formatter.date(from: $1.month)! }
        } catch {
            print("Failed to fetch issue and returns data: \(error)")
            return []
        }
    }
    
    func fetchGenreData() async -> ([(genre: String, percentage: Double)], Int) {
        let booksCollection = db.collection("books")
        let googleBooksService = GoogleBookService()
        
        do {
            let snapshot = try await booksCollection.getDocuments()
            let totalBooks = snapshot.documents.count
            let books = snapshot.documents.compactMap { doc -> (isbn: String, genre: String?)? in
                guard let isbn = doc.data()["isbnOfTheBook"] as? String else { return nil }
                return (isbn, doc.data()["genre"] as? String)
            }
            
            var genreCounts: [String: Int] = [:]
            
            await withTaskGroup(of: (String, String?).self) { group in
                for book in books {
                    group.addTask {
                        if let genre = book.genre {
                            return (book.isbn, genre)
                        } else {
                            do {
                                let data = try await googleBooksService.createGoogleBookMetaData(isbn: book.isbn)
                                return (book.isbn, data.genre)
                            } catch {
                                print("Failed to fetch genre for ISBN \(book.isbn): \(error)")
                                return (book.isbn, nil)
                            }
                        }
                    }
                }
                
                for await (_, genre) in group {
                    if let genre = genre {
                        genreCounts[genre, default: 0] += 1
                    }
                }
            }
            
            let sortedGenres = genreCounts.sorted { $0.value > $1.value }
            
            var genreData: [(genre: String, percentage: Double)] = []
            var otherCount = 0
            
            for (index, (genre, count)) in sortedGenres.enumerated() {
                if index < 4 {
                    let percentage = Double(count) / Double(totalBooks) * 100
                    genreData.append((genre: genre, percentage: percentage))
                } else {
                    otherCount += count
                }
            }
            
            if otherCount > 0 {
                let otherPercentage = Double(otherCount) / Double(totalBooks) * 100
                genreData.append((genre: "Other", percentage: otherPercentage))
            }
            
            return (genreData, totalBooks)
        } catch {
            print("Failed to fetch genre data: \(error)")
            return ([], 0)
        }
    }
}
