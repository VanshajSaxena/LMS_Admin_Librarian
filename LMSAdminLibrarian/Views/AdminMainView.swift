import SwiftUI

struct AdminMainView: View {
    var body: some View {
        NavigationView {
            AdminSideBar( )
            AddCampaignEventsView() // Default detail view for admin
        }
    }
}
