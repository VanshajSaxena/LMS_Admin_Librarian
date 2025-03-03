import SwiftUI

struct AddBookView: View {
    @State private var numberOfCopies: String = ""
    @State private var column: String = ""
    @State private var shelf: String = ""
    @State private var selectedButton: String? = nil
    @Environment(\.presentationMode) var presentationMode
    
    // to get data from barcode scanning
    @State private var isPresented = false
    @State private var isbn: String = ""
    @State private var foundBooks: BooksAPI?
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    @State private var isShowingFilePicker = false
    @State private var selectedFileURL: URL?
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                
                buttonSection
                
                VStack {
                    Text("Add Book")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.horizontal, 100)
                }
                formSection
                
                doneButton
                    .padding(.horizontal, 250)
                    .padding(.top, 30)
            }
            
            .background(Color.white)
            .ignoresSafeArea()
        }
    }
    
    private var buttonSection: some View {
        HStack(spacing: 30) {
            
            Button(action: {
                isPresented.toggle()
            }, label: {
                Text("Scan ISBN")
                    .foregroundStyle(.themeOrange)
                    .padding()
                    .overlay(){
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.themeOrange, lineWidth: 1)
                    }
            })
            .sheet(isPresented: $isPresented) {
                BarCodeScanner(isbn: $isbn,
                               foundBooks: $foundBooks)
            }
            
            Divider()
                .frame(width: 1.5, height: 70)
            
                .padding(.top,20)
                .background(Color.themeOrange)
            
            Button(action: {
                isShowingFilePicker  = true
            }, label: {
                Text("Import XLSX")
                    .foregroundStyle(.themeOrange)
                    .padding()
                    .overlay(){
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.themeOrange, lineWidth: 1)
                    }
            })
            .sheet(isPresented: $isShowingFilePicker) {
                FilePicker( documentTypes: ["public.item"], onPick: {url in self.selectedFileURL = url
                    self.isShowingFilePicker = false
                    parseExcelFile(at: selectedFileURL!, completion: { books in updateFirestore(with: books)})
                    showAlert = true
                }, showAlert: $showAlert)
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Success!"), message: Text("File selected and processed."), dismissButton: .default(Text("OK")))
            }
        }
        .padding(.top,30)
    }
    
    
    private var formSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            formField(title: "ISBN Number", text: $isbn, placeholder: "Enter the ISBN number")
                .keyboardType(.numbersAndPunctuation)
            formField(title: "No. of Copies", text: $numberOfCopies, placeholder: "Enter the number of copies")
                .keyboardType(.numbersAndPunctuation)
            formField(title: "Column", text: $column, placeholder: "Enter the column")
            formField(title: "Shelf", text: $shelf, placeholder: "Enter the shelf")
        }
        .padding(.horizontal, 100) // Adjusted padding to make the form wider
    }
    
    private func formField(title: String, text: Binding<String>, placeholder: String) -> some View {
        VStack(alignment: .leading) {
            Text(title)
                .padding(.leading, 20)
                .font(.headline)
                .foregroundColor(Color("ThemeOrange"))
            TextField(placeholder, text: text)
                .foregroundStyle(.black)
                .padding()
                .background(Color.white)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color(.black), lineWidth: 0.4)
                )
        }
    }
    
    private var doneButton: some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
            // Add book action
            updateFirestore(with: [BookRecord(isbnOfTheBook: isbn,
                                              totalNumberOfCopies: Int(numberOfCopies) ?? 2,
                                              numberOfIssuedCopies: 0,
                                              bookColumn: column,
                                              bookShelf: shelf)])
            
            
        }) {
            Text("Done")
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(width: 300)
                .background(Color("ThemeOrange"))
                .cornerRadius(8)
                .padding(.bottom, 70)
        }
        
    }
}

struct AddBookView_Previews: PreviewProvider {
    static var previews: some View {
        AddBookView()
    }
}
