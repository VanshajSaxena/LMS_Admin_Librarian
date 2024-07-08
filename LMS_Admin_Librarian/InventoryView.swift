import SwiftUI

struct BookInventoryView: Identifiable {
    var id = UUID()
    var name: String
    var author: String
    var genre: String
    var pages: Int
    var copies: Int
    var column: String
    var shelf: String
}

struct InventoryView: View {
    @State private var searchQuery: String = ""
    @State private var isShowingAddBookView = false

    @State private var books: [BookInventoryView] = [
        BookInventoryView(name: "For Whom The Bell Tolls", author: "Ernest Hemingway", genre: "War, Thriller, Action", pages: 300, copies: 5, column: "Col 2", shelf: "Shelf 4"),
        BookInventoryView(name: "The Three Musketeers", author: "Alexandre Dumas", genre: "Adventure, Fiction", pages: 230, copies: 3, column: "Col 2", shelf: "Shelf 3")
    ]

    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                VStack(alignment: .leading, spacing: 40) {
                    HStack {
                        Text("Inventory")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .padding(.leading, 50)
                        Spacer()
                        
                        // My Account action
                        Button(action: {
                            // My Account action
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
                                .frame(height: 40)
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
                                .padding(.trailing, 5)
                            }
                        }
                        .frame(maxWidth: geometry.size.width * 0.5)
                        .padding(.leading, geometry.size.width * 0.05)

                        Spacer()

                        // Filter action
                        Button(action: {
                            // Filter action
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

                        Rectangle().frame(width: 1, height: 65).foregroundColor(Color("ThemeOrange"))

                        // Add Book action
                        Button(action: {
                            isShowingAddBookView = true
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
                        .padding(.trailing, geometry.size.width * 0.05)
                        .padding(.leading, 7)
                    }

                    HStack(spacing: 90) {
                        Text("Name")
                            .font(.headline)
                            .foregroundColor(Color("ThemeOrange"))

                        Text("Author")
                            .font(.headline)
                            .foregroundColor(Color("ThemeOrange"))

                        Text("Genre")
                            .font(.headline)
                            .foregroundColor(Color("ThemeOrange"))

                        Text("Pages")
                            .font(.headline)
                            .foregroundColor(Color("ThemeOrange"))

                        Text("Copies")
                            .font(.headline)
                            .foregroundColor(Color("ThemeOrange"))

                        Text("Column")
                            .font(.headline)
                            .foregroundColor(Color("ThemeOrange"))

                        Text("Shelf")
                            .font(.headline)
                            .foregroundColor(Color("ThemeOrange"))
                    }
                    .padding(.horizontal, geometry.size.width * 0.05)
                    .padding(.top, 40)

                    // Book details
                    List {
                        ForEach(books) { book in
                            HStack {
                                Text(book.name)
                                    .frame(maxWidth: .infinity, alignment: .leading)

                                Text(book.author)
                                    .frame(maxWidth: .infinity, alignment: .leading)

                                Text(book.genre)
                                    .frame(maxWidth: .infinity, alignment: .leading)

                                Text("\(book.pages)")
                                    .frame(maxWidth: .infinity, alignment: .leading)

                                Text("\(book.copies)")
                                    .frame(maxWidth: .infinity, alignment: .leading)

                                Text(book.column)
                                    .frame(maxWidth: .infinity, alignment: .leading)

                                Text(book.shelf)
                                    .frame(maxWidth: .infinity, alignment: .leading)

                                // Edit button
                                Button(action: {
                                    // Edit action
                                }) {
                                    Image(systemName: "pencil")
                                        .foregroundColor(.black)
                                }
                                .padding(.horizontal, 5)

                                // Delete button
                                Button(action: {
                                    // Delete action
                                }) {
                                    Image(systemName: "trash")
                                        .foregroundColor(.red)
                                }
                                .padding(.horizontal, 1)
                            }
                            .padding(.vertical, 20)
                        }
                    }
                    .padding(.horizontal, 30)

                    HStack {
                        Text("This is the \n End Folks!")
                            .font(.system(size: 40))
                            .fontWeight(.bold)
                            .foregroundColor(Color("ThemeOrange"))
                        Spacer()
                    }
                    .padding(40)
                }
                .background(Color("BackgroundColor").edgesIgnoringSafeArea(.all))
                .sheet(isPresented: $isShowingAddBookView) {
                    AddBookView()
                }
            }
        }
    }
}

struct InventoryView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            InventoryView()
                
                .previewInterfaceOrientation(.landscapeLeft)
            InventoryView()
                
        }
    }
}
