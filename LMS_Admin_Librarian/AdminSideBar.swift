import SwiftUI

struct AdminSidebar: View {
    var body: some View {
        List {
            NavigationLink(destination: AddLibrarianView()) {
                Label("Add Librarian", systemImage: "person.badge.plus")
            }
            NavigationLink(destination: AdminInventoryView()) {
                Label("Admin Inventory", systemImage: "books.vertical")
            }
            // Add more links as needed
        }
        .listStyle(SidebarListStyle())
        .navigationTitle("Admin Sidebar")
    }
}
