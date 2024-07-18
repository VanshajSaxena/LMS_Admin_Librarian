import SwiftUI

struct AdminSideBar: View {
    @State private var selectedButton: String? = "Analytics" // Set the initial selected button
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var isLoggedOut = false
    
    var body: some View {
        VStack {
            Text("App Name")
                .font(.largeTitle)
                .fontWeight(.black)
                .foregroundColor(.white)
                .padding(.top, 150)
                .padding(.bottom, 50)
                .padding(.leading, 100)
            
            VStack(alignment: .leading, spacing: 30) {
                SidebarButton(imageName: "chart.bar", text: "Analytics", selectedButton: $selectedButton)
                SidebarButton(imageName: "archivebox", text: "Staff", selectedButton: $selectedButton)
                SidebarButton(imageName: "person", text: "Requests", selectedButton: $selectedButton)
                SidebarButton(imageName: "gearshape", text: "Settings", selectedButton: $selectedButton)
            }
            .padding(.horizontal, 30)
            
            Spacer()
            
            Button(action: {
                // Log out action
                authViewModel.logout()
                isLoggedOut = true
            }) {
                HStack {
                    Image(systemName: "power")
                    Text("LogOut")
                        .fontWeight(.bold)
                }
                .foregroundColor(.orange)
                .frame(maxWidth: 150, alignment: .center)
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                .padding(.leading, 120)
                .padding(.trailing, 20)
                .imageScale(.large)
            }
            .padding(.bottom, 30)
            .onChange(of: authViewModel.isAuthenticated) { oldValue, newValue in
                if !newValue {
                    isLoggedOut = true
                }
            }
            .sheet(isPresented: $isLoggedOut) {
                LoginView()
            }
        }
        .frame(maxWidth: 430)
        .background(Color("ThemeOrange"))
        .edgesIgnoringSafeArea(.all)
    }
}





struct SidebarButton: View {
    var imageName: String
    var text: String
    @Binding var selectedButton: String?
    
    var body: some View {
        NavigationLink(destination: destinationView(for: text), tag: text, selection: $selectedButton) {
            HStack {
                Image(systemName: imageName)
                    .foregroundColor(selectedButton == text ? .orange : .white)
                    .padding(.leading, 35)
                    .padding(.trailing, 15)
                    .imageScale(.large)
                Text(text)
                    .font(.title3)  // Increase font size
                    .foregroundColor(selectedButton == text ? .orange : .white)
                    .fontWeight(.semibold)
            }
            .padding(.vertical, 15)  // Adjust vertical padding
            .padding(.horizontal, 20)  // Adjust horizontal padding
            .frame(maxWidth: .infinity, alignment: .leading)  // Make the background wider
            .background(selectedButton == text ? Color.white : Color.clear)
            .cornerRadius(12)
            .padding(.leading, 100)  // Adjust leading padding to center the button
        }
        .buttonStyle(PlainButtonStyle()) // Ensure NavigationLink behaves like a button
    }
    
    @ViewBuilder
    func destinationView(for text: String) -> some View {
        switch text {
        case "Analytics":

            ScrollView {
                        VStack(alignment: .leading, spacing: 0) {
                            AdminAnalyticsView()
                            MembershipView()
                            AddCampaignEventsView()
                        }
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                    }
                    .edgesIgnoringSafeArea(.top)

        case "Staff":
            AddLibrarianView()
        case "Requests":
            AdminlView()
        case "Settings":
            LibrarianRequestsView()
        default:
            EmptyView()
        }
    }
}

struct AnalyticsView: View {
    var body: some View {
        AdminAnalyticsView()
    }
}

struct ProfileView: View {
    var body: some View {
        Text("Profile View")
    }
}

struct SettingsView: View {
    var body: some View {
        Text("Settings View")
    }
}




