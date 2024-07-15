import SwiftUI

struct LibrarianMainView: View {
    var body: some View {
        NavigationView {
            LibrarianSideBar()
            LibrariankView() // Default detail view for librarian
        }
    }
}
