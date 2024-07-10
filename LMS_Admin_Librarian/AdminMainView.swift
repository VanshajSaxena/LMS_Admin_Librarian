import SwiftUI

struct AdminMainView: View {
    var body: some View {
        NavigationView {
            AdminSidebar()
            AdminDefaultView() // Default detail view for admin
        }
    }
}
