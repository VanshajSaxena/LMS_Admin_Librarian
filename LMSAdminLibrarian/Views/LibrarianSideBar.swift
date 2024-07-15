import SwiftUI

struct LibrarianSideBar: View {
    @State private var selecteddButton: String? = "Dashboard" // Set the initial selected button
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
                LibrarianSidebarButton(imageName: "house", text: "Dashboard", selectedButton: $selecteddButton)
                LibrarianSidebarButton(imageName: "book", text: "Inventory", selectedButton: $selecteddButton)
                LibrarianSidebarButton(imageName: "person", text: "GenerateRequests", selectedButton: $selecteddButton)
                LibrarianSidebarButton(imageName: "gearshape", text: "Settings", selectedButton: $selecteddButton)
                
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

struct LibrarianSidebarButton: View {
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
        case "Dashboard":
            DashboardView()
        case "Inventory":
            InventoryView()
        case "GenerateRequests":
            LibrariankView()
        case "Settings":
            LibrarianSettingsView()
        default:
            EmptyView()
        }
    }
}

// Sample Views for Librarian's Sidebar

struct BooksView: View {
    var body: some View {
        Text("Books View")
    }
}

struct LibrarianProfileView: View {
    var body: some View {
        Text("Profile View")
    }
}

struct LibrarianSettingsView: View {
    var body: some View {
        Text("Settings View")
    }
}
