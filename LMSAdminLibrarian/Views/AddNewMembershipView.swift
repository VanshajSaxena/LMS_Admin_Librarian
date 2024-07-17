//
//  AddNewMembershipView.swift
//  LMSAdminLibrarian
//
//  Created by Aida Sharon Bruce on 15/07/24.
//

//
//  AddNewMembershipView.swift
//  LMSAdminLibrarian
//
//  Created by Aida Sharon Bruce on 15/07/24.
//

import SwiftUI

struct AddNewMembershipView: View {
    @StateObject private var viewModel: MembershipViewModel = MembershipViewModel()
    @State private var membershipTime: String = ""
    @State private var price: Double = 0
    @State private var perks: [String] = [""]
    @State private var isPremium: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Add Membership")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Group {
                Text("Time(In months)")
                    .font(.headline)
                    .foregroundColor(Color("AccentColor"))
                    .padding(.top)
                    .padding()
                
                TextField("Enter the Time Duration of the Membership", text: $membershipTime)
                    .padding()
                    .background(Color(.white))
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray, lineWidth: 0.8)
                    )
                    .multilineTextAlignment(.leading)
            }
            
            Group {
                Text("Price")
                    .font(.headline)
                    .foregroundColor(Color("AccentColor"))
                    .padding(.top)
                    .padding()
                
                HStack {
                    Text("0")
                    Slider(value: $price, in: 0...5000, step: 10)
                        .accentColor(Color("AccentColor"))
                    Text("5000")
                }
                
                Text("Selected Price: \(Int(price))")
                    .font(.subheadline)
                    .foregroundColor(Color("AccentColor"))
                    .padding()
            }
            
            Group {
                Text("Perks")
                    .font(.headline)
                    .foregroundColor(Color("AccentColor"))
                    .padding(.top)
                    .padding()
                
                ForEach($perks.indices, id: \.self) { index in
                    TextField("Enter a perk", text: $perks[index])
                        .padding()
                        .background(Color(.white))
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray, lineWidth: 0.8)
                        )
                        .multilineTextAlignment(.leading)
                        .padding(.bottom, 5)
                }
                
                Button(action: {
                    perks.append("")
                }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Add Perk")
                    }
                    .padding()
                    .background(Color("AccentColor"))
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
            }
            
            Group {
                Text("Premium Membership")
                    .font(.headline)
                    .foregroundColor(Color("AccentColor"))
                    .padding(.top)
                    .padding()
                
                Toggle(isOn: $isPremium) {
                    Text("Is Premium?")
                        .font(.headline)
                        .foregroundColor(Color("AccentColor"))
                }
                .tint(.accentColor)
                .padding()
            }
            
            Spacer()
            
            HStack {
                Spacer()
                Button(action: {
                    // "Done" button action
                    
                    Task {
                        await viewModel.updateFirestore(with: Membership(price: Int(price), duration: Int(membershipTime) ?? 1, perks: perks, isPremium: isPremium))
                    }
                }) {
                    Text("Done")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: 200, alignment: .center)
                        .padding()
                        .background(Color("AccentColor"))
                        .cornerRadius(10)
                        
                }
                Spacer()
            }
            .padding(.top)
        }
        .padding(80)
        .padding(.bottom, 150)
        .padding(.top, 150)
        
    }
}

#Preview {
    AddNewMembershipView()
}



