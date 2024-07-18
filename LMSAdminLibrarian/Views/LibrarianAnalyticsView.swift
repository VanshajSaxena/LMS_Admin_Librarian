//
//  LibrarianAnalyticsView.swift
//  LMSAdminLibrarian
//
//  Created by Mahak garg on 18/07/24.
//
import SwiftUI

struct LibrarianAnalyticsView: View {
    @State private var selectedDate = Date()
    @State private var selectedIndex: Int? = nil
    @StateObject private var viewModel: AdminAnalyticsViewModel = AdminAnalyticsViewModel()
    @State private var showPopover = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Spacer()
                    Button(action: {
                        // Action for My Account
                    }) {
                        HStack {
                            Image(systemName: "person.circle")
                            Text("My Account")
                        }
                        .padding()
                        .background(Color("ThemeOrange"))
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    .padding(.trailing, 30)
                    .padding(.top, 30)
                }
                .padding()
                
                HStack(alignment: .center) {
                    Text("Monthly \nAnalytics")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    CustomDatePicker(date: $selectedDate)
                        .frame(width: 80, height: 25)
                        .padding()
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color("ThemeOrange"), lineWidth: 1))
                        .padding(.trailing, 10)
                    
                    Button(action: {
                        showPopover.toggle()
                    }) {
                        Image(systemName: "square.and.arrow.up")
                            .padding()
                            .background(Color("ThemeOrange"))
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    .popover(isPresented: $showPopover) {
                        // NotificationPopoverView()
                    }
                }
                .padding(.horizontal)
                .padding(.trailing, 50)
                .padding(.leading, 20)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        ForEach(viewModel.analyticsData.indices, id: \.self) { index in
                            AnalyticsButton(
                                viewModel: viewModel,
                                data: viewModel.analyticsData[index],
                                isSelected: selectedIndex == index,
                                action: { selectedIndex = index }
                            )
                        }
                    }
                }
                .task {
                    await viewModel.updateUIwithChanges()
                }
                .padding(.top, 20)
                .padding(.leading, 50)
                
                // Add more views here
                VStack(spacing: 20) {
                    AddCampaignEventsView()
                    
                    
                    
                    // Add other views or components as needed
                }
                .padding(.top, 20)
                .padding(.leading, 50)
            }
            .padding()
            .background(Color("BackgroundColor"))
        }
        .edgesIgnoringSafeArea(.all)
    }
}
