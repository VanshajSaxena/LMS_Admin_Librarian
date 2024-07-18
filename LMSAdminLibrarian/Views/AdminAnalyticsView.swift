//import SwiftUI
//
//struct AdminAnalyticsView: View {
//    @State private var selectedDate = Date()
//    @State private var selectedIndex: Int? = nil
//    @StateObject private var viewModel: AdminAnalyticsViewModel = AdminAnalyticsViewModel()
//    @State private var showPopover = false
//
//    var body: some View {
//        ScrollView {
//            VStack(alignment: .leading, spacing: 20) {
//                HStack {
//                    Spacer()
//                    HStack {
//                        Button(action: {
//                            // Action for My Account
//
//                        }) {
//                            Image(systemName: "bell")
//                                .imageScale(.large)
//                                .padding()
//                                .background(Color("ThemeOrange"))
//                                .foregroundColor(.white)
//                                .clipShape(RoundedRectangle(cornerRadius: 10))
//                        }
//
//                        Text("Fable")
//
//                            .font(.system(size: 50))
//                            .foregroundColor(.themeOrange)
//                            .fontWeight(.bold)
//                            .padding(.leading, 10) // Adjust spacing as needed
//                    }
//                    .padding(.trailing, 30)
//                    .padding(.top, 30)
//                }
//                .padding()
//
//                HStack(alignment: .center) {
//                    Text("Monthly \nAnalytics")
//                        .font(.largeTitle)
//                        .fontWeight(.bold)
//
//                    Spacer()
//
//                    CustomDatePicker(date: $selectedDate)
//                        .frame(width: 140, height: 40)
//                        .padding()
//                        .background(Color.white)
//                        .clipShape(RoundedRectangle(cornerRadius: 10))
//                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color("ThemeOrange"), lineWidth: 1))
//
//                        .frame(alignment: .center)
//
//                }
//
//                .padding(.horizontal)
//                .padding(.trailing)
//                .padding(.leading, 20)
//
//                ScrollView(.horizontal, showsIndicators: false) {
//                    HStack(spacing: 20) {
//                        ForEach(viewModel.analyticsData.indices, id: \.self) { index in
//                            AnalyticsButton(
//                                viewModel: viewModel,
//                                data: viewModel.analyticsData[index],
//                                isSelected: selectedIndex == index,
//                                action: { selectedIndex = index }
//                            )
//                        }
//                    }
//                }
//                .task {
//                    await viewModel.updateUIwithChanges()
//                }
//                .padding(.top, 20)
//                .padding(.leading, 50)
//
//                // Add other views below the main content
//                MembershipView()
//
//                // Add more views as needed
//            }
//            .padding()
//            .background(Color("BackgroundColor"))
//        }
//
//    }
//}
//
//struct AnalyticsButton: View  {
//    @ObservedObject var viewModel: AdminAnalyticsViewModel
//    var data: AnalyticsData
//    var isSelected: Bool
//    var action: () -> Void
//
//    var body: some View {
//        Button(action: action) {
//            VStack(spacing: 20) {
//                Image(systemName: data.image)
//                    .font(.system(size: 43))
//                    .foregroundStyle(Color("ThemeOrange"))
//
//                VStack(spacing: 5) {
//                    Text(data.amount)
//                        .font(.system(size: 40, weight: .heavy))
//                    Text(data.title)
//                        .font(.system(size: 22))
//                }
//
//                Text(data.rate)
//                    .font(.system(size: 20))
//                    .foregroundColor(.green)
//            }
//            .padding(40)
//            .frame(width: 210, height: 215)
//            .foregroundColor(isSelected ? .white : .black)
//            .background(isSelected ? Color("ThemeOrange") : Color.white)
//            .clipShape(RoundedRectangle(cornerRadius: 10))
//        }
//    }
//}
//
//struct AnalyticsData {
//    var image: String
//    var amount: String
//    var title: String
//    var rate: String
//}
//
//
//struct AdminAnalyticsView_Previews: PreviewProvider {
//    static var previews: some View {
//        AdminAnalyticsView()
//    }
//}



import SwiftUI

struct AdminAnalyticsView: View {
    @State private var selectedDate = Date()
    @State private var selectedIndex: Int? = nil
    @StateObject private var viewModel: AdminAnalyticsViewModel = AdminAnalyticsViewModel()
    @State private var showPopover = false
    @State private var showAdminRequestView = false // State variable to control sheet presentation

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Spacer()
                    HStack {
                        Button(action: {
                            showAdminRequestView = true // Show the sheet
                            // Reset notification count to 0
                        }) {
                            ZStack {
                                Image(systemName: "bell")
                                    .imageScale(.large)
                                    .padding()
                                    .background(Color("ThemeOrange"))
                                    .foregroundColor(.white)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                        }
                        
                        Text("Fable")
                            .font(.system(size: 50))
                            .foregroundColor(.themeOrange)
                            .fontWeight(.bold)
                            .padding(.leading, 10) // Adjust spacing as needed
                    }
                    .padding(.trailing, 30)
                    .padding(.top, 30)
                }
                .padding(.horizontal)
                .padding(.top, 20)
                
                HStack(alignment: .center) {
                    Text("Monthly \nAnalytics")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    CustomDatePicker(date: $selectedDate)
                        .frame(width: 140, height: 40)
                        .padding()
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color("ThemeOrange"), lineWidth: 1))
                        .frame(alignment: .center)
                    
                }
                .padding(.horizontal)
                .padding(.trailing)
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
                
                // Add other views below the main content
                
                
                // Add more views as needed
            }
            .padding()
            .background(Color("BackgroundColor"))
            .sheet(isPresented: $showAdminRequestView) {
                AdminRequestView()
            }
        }
    }
}

struct BadgeView: View {
    var count: Int
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.red)
                .frame(width: 20, height: 20)
            Text("\(count)")
                .foregroundColor(.white)
                .font(.system(size: 12))
        }
    }
}

struct AnalyticsButton: View  {
    @ObservedObject var viewModel: AdminAnalyticsViewModel
    var data: AnalyticsData
    var isSelected: Bool
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 20) {
                Image(systemName: data.image)
                    .font(.system(size: 43))
                    .foregroundStyle(Color("ThemeOrange"))
                
                VStack(spacing: 5) {
                    Text(data.amount)
                        .font(.system(size: 40, weight: .heavy))
                    Text(data.title)
                        .font(.system(size: 22))
                }
                
                Text(data.rate)
                    .font(.system(size: 20))
                    .foregroundColor(.green)
            }
            .padding(40)
            .frame(width: 210, height: 215)
            .foregroundColor(isSelected ? .white : .black)
            .background(isSelected ? Color("ThemeOrange") : Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
}



struct AdminAnalyticsView_Previews: PreviewProvider {
    static var previews: some View {
        AdminAnalyticsView()
    }
}
