import SwiftUI

struct LibrarianMainView: View {
    var body: some View {
        NavigationView {
            LibrarianSidebar()
            LibrarianDefaultView() // Default detail view for librarian
        }
    }
}
