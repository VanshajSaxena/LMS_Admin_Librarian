
import SwiftUI

struct InventoryView: View {
    @State private var searchQuery: String = ""
    @State private var showAddBookView: Bool = false
    @StateObject private var viewModel = InventoryViewModel()
    
    private func updateInventoryTableView() async {
        do {
            let firestoreService = FirestoreService()
            let isbnList = try await firestoreService.getISBNList()
            print("Fetched \(isbnList.count) books")
            await viewModel.updateInventoryTableView(isbnList: isbnList)
        }
        catch {
            let error = NSError(domain: "Error fetching ISBN List", code: -1, userInfo: nil)
            print("Error: \(error.localizedDescription)")
        }
    }
    
    var body: some View {
        VStack {
            // Header and search bar
            HStack {
                Text("Inventory")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.leading, 50)
                Spacer()
                
                // My Account action
                
            }
            .padding(.top, 50)
            
            // Search bar
            HStack(spacing: 10) {
                ZStack {
                    TextField("Search the book", text: $viewModel.searchQuery)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color("ThemeOrange"), lineWidth: 2)
                        )
                        .onChange(of: viewModel.searchQuery) { newValue in
                            viewModel.searchBooks(query: newValue)
                        }
                    
                    
                }
                .frame(maxWidth: .infinity)
                .padding(.leading, 50)
                
                Spacer()
                
                // Add Book action
                Button(action: {
                    showAddBookView.toggle()
                }) {
                    HStack {
                        Image(systemName: "plus.square")
                        Text("Add Book")
                    }
                    .padding()
                    .background(Color("ThemeOrange"))
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                .padding(.trailing, 50).padding(.leading, 7)
            }
            .padding(.top, 10)
            
            // Book table
            Table(viewModel.books) {
                TableColumn("S.No") { book in
                    if let index = viewModel.books.firstIndex(of: book) {
                        Text("\(index + 1)")
                    }
                }
                TableColumn("Name", value: \.title)
                TableColumn("Author", value: \.authors)
                TableColumn("Genre", value: \.genre)
                TableColumn("Pages") { book in
                    Text("\(book.pageCount)")
                }
                TableColumn("Copies") { book in
                    Text("\(book.totalNumberOfCopies)")
                }
                TableColumn("Column", value: \.bookColumn)
                TableColumn("Shelf", value: \.bookShelf)
            }
            .task {
                await updateInventoryTableView()
            }
            .cornerRadius(8)
            .padding(.horizontal, 50)
            .padding(.bottom, 30)
            .padding(.top, 12)
        }
        .background(Color("BackgroundColor").edgesIgnoringSafeArea(.all))
        .sheet(isPresented: $showAddBookView) {
            AddBookView()
        }
    }
}

struct InventoryView_Previews: PreviewProvider {
    static var previews: some View {
        InventoryView()
    }
}
