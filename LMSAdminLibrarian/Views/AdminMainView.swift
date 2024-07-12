import SwiftUI

struct AdminMainView: View {
    var body: some View {
        NavigationView {
            AdminSideBar( )
            AnalyticsView() // Default detail view for admin
        }
    }
}
