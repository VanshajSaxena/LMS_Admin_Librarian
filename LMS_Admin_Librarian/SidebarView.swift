import SwiftUI

struct SidebarView: View {
    @State private var showSidebar = false
    @State private var showAnalytics = false

    var body: some View {
        ZStack(alignment: .leading){
            
            VStack {
                HStack {
                    // Sidebar Button
                    Button(action: {
                        withAnimation {
                            showSidebar.toggle()
                            print("\(showSidebar)")
                        }
                    }) {
                        Image(systemName: "sidebar.leading")
                            .foregroundColor(.orange)
                            .padding(10)
                            .clipShape(Circle())
                            .font(.title2)
                            .padding(20)
                    }
                    Spacer()
                }
                .cornerRadius(30)
                Spacer()
            }
            .background(Color.white)
            .cornerRadius(showSidebar ? 20 : 0)
            .shadow(radius: showSidebar ? 20 : 0)
            .offset(x: showSidebar ? 250 : 0)
            .animation(.easeInOut)

            // Sidebar Content
            if showSidebar {
                SidebarContent()
                    .frame(width: 250) // Adjust width to match the design
                    .background(Color(red: 242/255, green: 137/255, blue: 79/255))
                    .transition(.move(edge: .leading))
                    .animation(.easeInOut)
            }
            
            if showAnalytics {
                AddBookViewNew()
                    .frame(width: 1500)
                    .transition(.move(edge: .leading))
                    .animation(.easeInOut)
            }
            
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct SidebarContent: View {
    var body: some View {
        VStack(alignment: .leading) {
            // App Name
            Text("App Name")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.top, 50)
                .padding(.leading, 20)
            
            Spacer()
            
            // Analytics Button
            Button(action: {
                // Action for Analytics
            }) {
                HStack {
                    Image(systemName: "chart.bar")
                        .foregroundColor(.white)
                    Text("Analytics")
                        .foregroundColor(.white)
                        .fontWeight(.medium)
                }
                .padding()
                .background(Color.white.opacity(0.2))
                .cornerRadius(25)
            }
            .padding(.bottom, 20)
            .padding(.leading, 20)
            
            // Inventory Button
//            NavigationLink(destination: AddBookView()) {
//                HStack {
//                    Image(systemName: "doc.text")
//                        .foregroundColor(.white)
//                    Text("Inventory")
//                        .foregroundColor(.white)
//                        .fontWeight(.medium)
//                }
//                .padding()
//            }
            Button(action: {
                
            }) {
                HStack {
                    Image(systemName: "doc.text")
                        .foregroundColor(.white)
                    Text("Inventory")
                        .foregroundColor(.white)
                        .fontWeight(.medium)
                }
                .padding()
            }
            .padding(.bottom, 20)
            .padding(.leading, 20)
            
            
            // Profile Button
            Button(action: {
                // Action for Profile
            }) {
                HStack {
                    Image(systemName: "person")
                        .foregroundColor(.white)
                    Text("Profile")
                        .foregroundColor(.white)
                        .fontWeight(.medium)
                }
                .padding()
            }
            .padding(.bottom, 20)
            .padding(.leading, 20)
            
            // Settings Button
            Button(action: {
                // Action for Settings
            }) {
                HStack {
                    Image(systemName: "gearshape")
                        .foregroundColor(.white)
                    Text("Settings")
                        .foregroundColor(.white)
                        .fontWeight(.medium)
                }
                .padding()
            }
            .padding(.leading, 20)
            
            Spacer()
            
            // LogOut Button
            Button(action: {
                // Action for LogOut
            }) {
                HStack {
                    Image(systemName: "power")
                        .foregroundColor(.orange)
                    Text("LogOut")
                        .foregroundColor(.orange)
                        .fontWeight(.medium)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(25)
                .padding(.bottom, 50)
                .padding(.leading, 20)
            }
        }
    }
}

struct SidebarView_Previews: PreviewProvider {
    static var previews: some View {
        SidebarView()
    }
}

