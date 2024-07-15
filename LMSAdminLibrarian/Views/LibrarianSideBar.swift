import SwiftUI

struct LibrarianSideBar: View {
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
                SidebarButton(imageName: "archivebox", text: "Inventory", selectedButton: $selectedButton)
                SidebarButton(imageName: "person", text: "Profile", selectedButton: $selectedButton)
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
            .onChange(of: authViewModel.isAuthenticated, initial: true) { oldValue, newValue in
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
    
    @ViewBuilder
    func destinationView(for text: String) -> some View {
        switch text {
        case "Analytics":
            AnalyticsView()
        case "Inventory":
            InventoryView()
        case "Profile":
            ProfileView()
        case "Settings":
            SettingsView()
        default:
            EmptyView()
        }
    }
}

