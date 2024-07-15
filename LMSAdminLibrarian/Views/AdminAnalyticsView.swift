import SwiftUI

struct AdminAnalyticsView: View {
    @State private var selectedDate = Date()
    @State private var selectedIndex: Int? = nil
    @State private var isPresentingNewCardView = false
    
    let analyticsData: [AnalyticsData] = [
        AnalyticsData(image: "book.circle", amount: "13k", title: "Total Books", rate: "↑ 30%"),
        // Add more data if needed
    ]
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
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
                    //    .padding(.trailing, 30)
                    .padding(.top, 30)
                }
                .padding(.top)
                .padding(.leading)
                .padding(.bottom)
                
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
                //   .padding(.horizontal)
                //                .padding(.trailing, 50)
                //                .padding(.leading, 20)
                
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
                //  .padding(.leading, 10)
                //  .padding(.trailing, 50)
                
                Text("Graphs")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 50)
                //  .padding(.leading, 40)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        Rectangle()
                            .fill(Color.white)
                            .frame(width: 400, height: 300)
                            .cornerRadius(10)
                        VStack(spacing: 16) {
                            Rectangle()
                                .fill(Color.white)
                                .frame(width: 200, height: 140)
                                .cornerRadius(10)
                            Rectangle()
                                .fill(Color.white)
                                .frame(width: 200, height: 140)
                                .cornerRadius(10)
                        }
                        Rectangle()
                            .fill(Color.white)
                            .frame(width: 400, height: 300)
                            .cornerRadius(10)
                        VStack(spacing: 16) {
                            Rectangle()
                                .fill(Color.white)
                                .frame(width: 200, height: 140)
                                .cornerRadius(10)
                            Rectangle()
                                .fill(Color.white)
                                .frame(width: 200, height: 140)
                                .cornerRadius(10)
                        }
                        VStack(spacing: 16) {
                            Rectangle()
                                .fill(Color.white)
                                .frame(width: 200, height: 140)
                                .cornerRadius(10)
                            Rectangle()
                                .fill(Color.white)
                                .frame(width: 200, height: 140)
                                .cornerRadius(10)
                        }
                        Rectangle()
                            .fill(Color.white)
                            .frame(width: 400, height: 300)
                            .cornerRadius(10)
                    }
                }
                .padding(.top, 20)
                
                HStack {
                    Text("Memberships")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.top, 50)
                    
                    Button(action: {
                        NewCardCreateButtonTapped()
                    }) {
                        HStack {
                            Image(systemName: "plus.app.fill")
                            Text("Add Membership")
                        }
                      
                            .padding()
                            .fontWeight(.bold)
                            .background(Color("ThemeOrange"))
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .padding(.top, 50)
                            .sheet(isPresented: $isPresentingNewCardView) {
                                AddNewMembershipView()
                            }
                        
                    }
                    .offset(x: 825)
                }
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 50) {
                        MembershipsCardView()
                        MembershipsCardAdd()
                        
                    }
                    .padding(.top)
                }
                
                Spacer()
            }
            .padding(.leading, 50)
            .padding(.trailing, 50)
            
        }
        .padding()
        .background(Color("BackgroundColor"))
        .edgesIgnoringSafeArea(.all)
        
    }
    func NewCardCreateButtonTapped() {
        isPresentingNewCardView = true
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


struct MembershipsCardAdd: View {
    @State private var isPresentingNewCardView = false
    
    var body: some View {
        VStack {
            Spacer()
            Button(action: {
                NewCardCreateButtonTapped()
            }) {
                Image(systemName: "plus")
                    .font(.title)
                    .foregroundColor(Color("AccentColor"))
            }
            Spacer()
        }
        .frame(width: 400, height: 500)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .stroke(style: StrokeStyle(lineWidth: 2, dash: [20]))
                .foregroundColor(Color("AccentColor"))
        )
        .background(Color.white)
        .cornerRadius(10)
        .sheet(isPresented: $isPresentingNewCardView) {
            AddNewMembershipView()
        }
    }
    
    func NewCardCreateButtonTapped() {
        isPresentingNewCardView = true
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
            .previewInterfaceOrientation(.landscapeLeft)
            .previewDevice("iPad Pro (11-inch) (3rd generation)")
    }
}

