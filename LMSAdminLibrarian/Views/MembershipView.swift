//
//  MembershipView.swift
//  LMSAdminLibrarian
//
//  Created by ayush yadav on 16/07/24.
//

import SwiftUI

struct MembershipView: View {
    @StateObject private var viewModel: MembershipViewModel = MembershipViewModel()
    @State private var showAddNewMemberView: Bool = false
    
    
    
    var body: some View {
        HStack {
        Text("Membership")
            .font(.largeTitle)
            .fontWeight(.bold)
        
            Spacer()
            
        Button(action: {
            showAddNewMemberView.toggle()
        }) {
            HStack {
                Image(systemName: "plus.app.fill")
                Text("Add Membership")
                    .bold()
            }
            .padding()
            .background(Color("ThemeOrange"))
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
        .padding(.leading, 40)
        .padding(.trailing, 40)
        .sheet(isPresented: $showAddNewMemberView) {
            ScrollView {
                AddNewMembershipView()
            }
            .edgesIgnoringSafeArea(.top)
            .padding(.leading,50)
            
        }
        .task {
            viewModel.membershipPlans = await viewModel.fetchMembershipPlans()
        }
        if !viewModel.membershipPlans.isEmpty {
            MembershipCardView(viewModel: viewModel)
        }
    }
}
#Preview {
    MembershipView()
}
