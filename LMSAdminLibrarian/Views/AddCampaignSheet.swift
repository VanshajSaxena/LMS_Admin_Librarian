//
//  AddCampaignSheet.swift
//  LMSAdminLibrarian
//
//  Created by Ayush Sharma on 12/07/24.
//

import SwiftUI

struct AddCampaignSheet: View {
    @State private var campaignName: String = ""
    @State private var price: Double = 0
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Date()
    @State private var showStartDatePicker: Bool = false
    @State private var showEndDatePicker: Bool = false
    @State private var campaignDetails: String = ""

    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Add Campaign")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(10)

                VStack(alignment: .leading, spacing: 10) {
                    Text("Name")
                        .font(.headline)
                        .foregroundColor(.orange)
                        .padding(10)
                    TextField("Enter the Name of the Campaign", text: $campaignName)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 5).strokeBorder(Color.gray, lineWidth: 1))
                }
                .padding(20)

                VStack(alignment: .leading, spacing: 10) {
                    Text("Price")
                        .font(.headline)
                        .foregroundColor(.orange)
                    Slider(value: $price, in: 0...100000, step: 1)
                    Text("\(Int(price))")
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
                .padding(20)

                VStack(alignment: .leading, spacing: 10) {
                    Text("Duration")
                        .font(.headline)
                        .foregroundColor(.orange)

                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("Start Date")
                                .font(.headline)
                                .foregroundColor(.black)
                                .frame(width: 100, alignment: .leading)

                            //Spacer()

                            Text(startDate, style: .date)
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 5).strokeBorder(Color.gray, lineWidth: 1))
                                .onTapGesture {
                                    self.showStartDatePicker.toggle()
                                }
                                .sheet(isPresented: $showStartDatePicker) {
                                    DatePicker("Select Start Date", selection: $startDate, displayedComponents: .date)
                                        .datePickerStyle(GraphicalDatePickerStyle())
                                        .padding()
                                        .onChange(of: startDate) { _ in
                                            self.showStartDatePicker = false
                                        }
                                }
                        }

                        HStack {
                            Text("End Date")
                                .font(.headline)
                                .foregroundColor(.black)
                                .frame(width: 100, alignment: .leading)

                                //Spacer()

                            Text(endDate, style: .date)
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 5).strokeBorder(Color.gray, lineWidth: 1))
                                .onTapGesture {
                                    self.showEndDatePicker.toggle()
                                }
                                .sheet(isPresented: $showEndDatePicker) {
                                    DatePicker("Select End Date", selection: $endDate, in: startDate..., displayedComponents: .date)
                                        .datePickerStyle(GraphicalDatePickerStyle())
                                        .padding()
                                        .onChange(of: endDate) { _ in
                                            self.showEndDatePicker = false
                                        }
                                }
                        }
                    }
                }
                .padding(20)

                VStack(alignment: .leading, spacing: 10) {
                    Text("Details")
                        .font(.headline)
                        .foregroundColor(.orange)
                    
                    TextEditor(text: $campaignDetails)
                        .frame(height: 200)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 5).strokeBorder(Color.gray, lineWidth: 1))
                        .onChange(of: campaignDetails) { newValue in
                            if campaignDetails.count > 250 {
                                campaignDetails = String(campaignDetails.prefix(250))
                            }
                        }
                }
                .padding(20)

                HStack {
                    Spacer()
                    Button(action: {
                        // Action for send request
                    }) {
                        Text("Send Request")
                            .padding()
                            .frame(maxWidth: 150, alignment: .center)
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    Spacer()
                }
                .padding(.top, 20)
                
                Spacer()
            }
            .padding()
            .frame(maxWidth: .infinity) // Make sure the content takes full width
        }
        .navigationViewStyle(StackNavigationViewStyle()) // Ensure proper navigation style for iPads
    }
}

struct AddCampaignView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AddCampaignSheet()
                .previewDevice("iPad Pro (11-inch) (3rd generation)")
            AddCampaignSheet()
                .previewDevice("iPad Pro (12.9-inch) (5th generation)")
        }
    }
}
