import SwiftUI

struct LibrarianMainView: View {
    var body: some View {
        NavigationView {
            LibrarianSideBar()
            AnalyticsView() // Default detail view for librarian
        }
    }
}
