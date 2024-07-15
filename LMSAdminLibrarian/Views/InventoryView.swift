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
                Button(action: {
                    
                }) {
                    HStack {
                        Image(systemName: "person.circle")
                        Text("My Account")
                    }
                    .padding()
                    .background(Color("ThemeOrange"))
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                .padding(.trailing, 50)
            }
            .padding(.top, 50)
            
            // Search bar
            HStack(spacing: 10) {
                ZStack {
                    TextField("Search the book", text: $searchQuery)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(8)
//                        .frame(height: 40)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color("ThemeOrange"), lineWidth: 2)
                        )
                    
                    HStack {
                        Spacer()
                        Button(action: {
                            // Action for Find button
                        }) {
                            Text("Find")
                                .foregroundColor(.white)
                                .padding(.horizontal, 30)
                                .padding(.vertical, 5)
                                .background(Color("ThemeOrange"))
                                .cornerRadius(8)
                        }
                        .padding(.trailing, 12)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.leading, 50)
                
                Spacer()
                
                // Filter action
                Button(action: {
                    
                }) {
                    HStack {
                        Image(systemName: "line.horizontal.3.decrease.circle")
                        Text("Filter")
                    }
                    .padding()
                    .foregroundColor(Color("ThemeOrange"))
                    .cornerRadius(8)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color("ThemeOrange")))
                }
                .padding(.trailing, 10)
                
                Divider()
                    .frame(width: 1.5, height: 40)
                    .padding(.top,20)
                    .background(Color.themeOrange)
                
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
                TableColumn("S.No"){
                    book in
                    let index = viewModel.books.firstIndex(of: book)
                    Text("\(index!+1)")
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
                
                TableColumn("Actions") { book in
                    HStack {
                        // Edit button
                        Button(action: {
                            // Edit action
                        }) {
                            Image(systemName: "pencil")
                                .foregroundColor(.black)
                        }
                        
                        // Delete button
                        Button(action: {
                            // Delete action
                        }) {
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                        }
                    }
                }
            }
            .task {
                await updateInventoryTableView()
            }
            .cornerRadius(8)
            .padding(.horizontal, 50)
            .padding(.bottom, 30)
            .padding(.top, 12)
            
//            Spacer() // Push the footer to the bottom
//            
//            HStack {
//                Text("This is the \n End Folks!")
//                    .font(.system(size: 40))
//                    .fontWeight(.bold)
//                    .foregroundColor(Color("ThemeOrange"))
//                Spacer()
//            }
//            .padding(40)
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
            .previewDevice("iPad Pro (11-inch) (3rd generation)")
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
