import SwiftUI

struct LibrarianSidebar: View {
    var body: some View {
        List {
            NavigationLink(destination: InventoryView()) {
                Label("Add Inventory", systemImage: "books.vertical")
            }
            NavigationLink(destination: LibrarianInventoryView()) {
                Label("Analytics", systemImage: "books.vertical")
            }
            // Add more links as needed
        }
        .listStyle(SidebarListStyle())
        .navigationTitle("Librarian Sidebar")
    }
}


import SwiftUI



struct AdminInventoryView: View {
    var body: some View {
        Text("Admin Inventory View")
            .navigationTitle("Admin Inventory")
    }
}

struct LibrarianInventoryView: View {
    var body: some View {
        Text("Librarian Inventory View")
            .navigationTitle("Librarian Inventory")
    }
}

struct AdminDefaultView: View {
    var body: some View {
        Text("Admin Default View")
            .navigationTitle("Admin Default View")
    }
}

struct LibrarianDefaultView: View {
    var body: some View {
        Text("Librarian Default View")
            .navigationTitle("Librarian Default View")
    }
}
