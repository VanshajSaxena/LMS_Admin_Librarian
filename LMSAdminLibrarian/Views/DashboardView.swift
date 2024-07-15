//
//  AnalyzeView.swift
//  LMSAdminLibrarian
//
//  Created by Aida Sharon Bruce on 13/07/24.
//

import SwiftUI

struct DashboardView: View {
    @State private var selectedMonth = "July"
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                HStack {
                    Text("Monthly Analytics")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Spacer()
                    Button(action: {
                        // Account action
                    }) {
                        HStack {
                            Image(systemName: "person.circle")
                            Text("My Account")
                        }
                        .padding()
                        .background(Color("AccentColor"))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                }
                .padding([.top, .horizontal])
                
                // Analytics Cards
                HStack(spacing: 16) {
                    AnalyticsCard(title: "Total Books", value: "13k", percentage: "↑ 30%")
                    AnalyticsCard(title: "Total Readers", value: "5k", percentage: "↑ 40%", isHighlighted: true)
                    AnalyticsCard(title: "Books Issued", value: "7k", percentage: "↑ 30%")
                    AnalyticsCard(title: "Total Readers", value: "5k", percentage: "↓ 40%")
                    AnalyticsCard(title: "Total Books", value: "13k", percentage: "↑ 30%")
                }
                .padding([.horizontal, .bottom])
                
                // Graphs Section
                Text("Graphs")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.horizontal)
                
                HStack {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 400, height: 300)
                        .cornerRadius(10)
                    VStack(spacing: 16) {
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(width: 200, height: 140)
                            .cornerRadius(10)
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(width: 200, height: 140)
                            .cornerRadius(10)
                    }
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .frame(width: 600) // Adjust width as needed
            .background(Color("background").edgesIgnoringSafeArea(.all))
            
            VStack(alignment: .leading, spacing: 20) {
                // Membership Section
                Text("Memberships")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.top)
                
                HStack {
                    MembershipCard()
                    DashedAddButton()
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .frame(width: 300) // Adjust width as needed
            .background(Color("background").edgesIgnoringSafeArea(.all))
        }
        .navigationBarHidden(true)
    }
}

struct AnalyticsCard: View {
    let title: String
    let value: String
    let percentage: String
    var isHighlighted = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(value)
                .font(.largeTitle)
                .fontWeight(.bold)
            Text(title)
                .foregroundColor(.gray)
            Text(percentage)
                .font(.footnote)
                .foregroundColor(isHighlighted ? .red : .green)
        }
        .padding()
        .background(isHighlighted ? Color("AccentColor") : Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

struct MembershipCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Unlock More with Premium")
                .font(.title3)
                .fontWeight(.bold)
            Text("Join the premium subscription to real more and exciting features that would enhance your experience!")
                .font(.footnote)
                .foregroundColor(.gray)
            HStack {
                Text("500 / month")
                    .font(.title3)
                    .fontWeight(.bold)
                Spacer()
                Button(action: {
                    // Read more action
                }) {
                    Text("Read More")
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .padding(.top, 8)
            VStack(alignment: .leading, spacing: 8) {
                Label("Book The Book", systemImage: "checkmark")
                Label("Unlimited Library Access", systemImage: "checkmark")
                Label("Kuch to ayega yaha", systemImage: "checkmark")
            }
            .font(.footnote)
        }
        .padding()
        .background(Color("AccentColor"))
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

struct DashedAddButton: View {
    var body: some View {
        VStack {
            Spacer()
            Image(systemName: "plus")
                .font(.title)
                .foregroundColor(Color("AccentColor"))
            Spacer()
        }
        .frame(width: 150, height: 200)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .stroke(style: StrokeStyle(lineWidth: 2, dash: [6]))
                .foregroundColor(Color("AccentColor"))
        )
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
            .previewInterfaceOrientation(.landscapeLeft)
            .previewDevice("iPad Pro (11-inch) (3rd generation)")
    }
}
