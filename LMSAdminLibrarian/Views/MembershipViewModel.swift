//
//  MembershipViewModel.swift
//  LMSAdminLibrarian
//
//  Created by ayush yadav on 16/07/24.
//

import Foundation
import FirebaseFirestore

final class MembershipViewModel: ObservableObject {
    @Published var membershipPlans: [Membership] = []
    
    func updateFirestore(with membershipPlan: Membership) async {
        let db = Firestore.firestore()
        
        do {
            let _: Void = try await db.collection("MembershipPlan").document().setData(membershipPlan.dictionary)
        } catch {
            print("Membership Cannot be updated\(error)")
        }
    }

    func fetchMembershipPlans() async -> [Membership] {
        let db = Firestore.firestore()
        var membershipPlans: [Membership] = []
        
        do {
            let snapshot = try await db.collection("MembershipPlan").getDocuments()
            for document in snapshot.documents {
                if let membership = try? document.data(as: Membership.self) {
                    membershipPlans.append(membership)
                }
            }
        } catch {
            print("Error fetching membership plans: \(error)")
        }
        
        return membershipPlans
    }
}
