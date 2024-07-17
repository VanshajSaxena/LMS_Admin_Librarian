import SwiftUI

struct AdminAnalyticsView: View {
    @State private var selectedDate = Date()
    @State private var selectedIndex: Int? = nil
    
    let analyticsData: [AnalyticsData] = [
        AnalyticsData(image: "book.circle", amount: "13k", title: "Total Books", rate: "↑ 30%"),
        // Add more data if needed
    ]
    
    var body: some View {
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
                    // Action for share button
                }) {
                    Image(systemName: "square.and.arrow.up")
                        .padding()
                        .background(Color("ThemeOrange"))
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
            .padding(.horizontal)
            .padding(.trailing, 50)
            .padding(.leading, 20)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(0..<15) { index in
                        AnalyticsButton(
                            data: analyticsData[0], // Use actual data instead of index 0
                            isSelected: selectedIndex == index,
                            action: { selectedIndex = index }
                        )
                    }
                }
            }
            .padding(.top, 20)
            .padding(.leading, 50)
    
        }
        .padding()
        .background(Color("BackgroundColor"))
        .edgesIgnoringSafeArea(.all)
    }
}

struct AnalyticsButton: View {
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

struct AnalyticsData {
    var image: String
    var amount: String
    var title: String
    var rate: String
}

struct AdminAnalyticsView_Previews: PreviewProvider {
    static var previews: some View {
        AdminAnalyticsView()
    }
}

