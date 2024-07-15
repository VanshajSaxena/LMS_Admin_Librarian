import SwiftUI

struct InventoryView: View {
    @State private var searchQuery: String = ""
    @State private var showAddBookView: Bool = false
    @StateObject private var viewModel = InventoryViewModel()
    @State private var books: [BookInventoryView] = [
        // Sample data
        BookInventoryView(name: "Book1", author: "Author1", genre: "Genre1", pages: 123, copies: 1, column: "A", shelf: "1"),
        BookInventoryView(name: "Book2", author: "Author2", genre: "Genre2", pages: 456, copies: 2, column: "B", shelf: "2"),
        
        BookInventoryView(name: "Book2", author: "Author2", genre: "Genre2", pages: 456, copies: 2, column: "B", shelf: "2"),
        
        BookInventoryView(name: "Book2", author: "Author2", genre: "Genre2", pages: 456, copies: 2, column: "B", shelf: "2"),
        
        BookInventoryView(name: "Book2", author: "Author2", genre: "Genre2", pages: 456, copies: 2, column: "B", shelf: "2"),
        
        BookInventoryView(name: "Book2", author: "Author2", genre: "Genre2", pages: 456, copies: 2, column: "B", shelf: "2")
    ]

    struct BookInventoryView: Identifiable,Equatable {
        let id = UUID()
        let name: String
        let author: String
        let genre: String
        let pages: Int
        let copies: Int
        let column: String
        let shelf: String
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
            Table(books) {
                TableColumn("S.No"){
                    book in
                    let index = books.firstIndex(of: book)
                    Text("\(index!+1)")
                }
                TableColumn("Name", value: \.name)
                TableColumn("Author", value: \.author)
                TableColumn("Genre", value: \.genre)
                TableColumn("Pages") { book in
                    Text("\(book.pages)")
                }
                TableColumn("Copies") { book in
                    Text("\(book.copies)")
                }
                TableColumn("Column", value: \.column)
                TableColumn("Shelf", value: \.shelf)
                
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
            .padding(.horizontal, 50)
            .padding(.bottom, 30)
            .padding(.top, 12)
            .cornerRadius(30)
            
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
