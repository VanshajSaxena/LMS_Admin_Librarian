//
//  AddNewMembershipView.swift
//  LMSAdminLibrarian
//
//  Created by Aida Sharon Bruce on 15/07/24.
//

import SwiftUI

struct AddNewMembershipView: View {
    
    @State private var membershipName: String = ""
    @State private var price: Double = 0
    @State private var perks: String = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Add Membership")
                .font(.largeTitle)
                .fontWeight(.bold)

            Group {
                Text("Name")
                    .font(.headline)
                    .foregroundColor(Color("AccentColor"))
                    .padding(.top)
                    .padding()
                
                TextField("Enter the Name of the Membership", text: $membershipName)
                    .padding()
                    .background(Color(.white))
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray, lineWidth: 0.8)
                    )
            }


            Group {
                Text("Price")
                    .font(.headline)
                    .foregroundColor(Color("AccentColor"))
                    .padding(.top)
                    .padding()
                
                HStack {
                    Text("0")
                    Slider(value: $price, in: 0...100000, step: 1)
                        .accentColor(Color("AccentColor"))
                    Text("100000")
                }
            }

            Group {
                Text("Perks")
                    .font(.headline)
                    .foregroundColor(Color("AccentColor"))
                    .padding(.top)
                    .padding()
                
                TextField("Enter the Perks you want in the Membership", text: $perks)
                    .padding()
                    .frame(height: 250)
                    .background(Color(.white))
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray, lineWidth: 0.8)
                    )
            }
            

            Spacer()

            
            HStack {
                Spacer()
                Button(action: {
                    // Handle the "Done" button action
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
