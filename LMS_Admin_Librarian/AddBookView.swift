import SwiftUI

struct AddBookView: View {
    @State private var numberOfCopies: String = ""
    @State private var column: String = ""
    @State private var shelf: String = ""
    @State private var selectedButton: String? = nil
    
    // to get data from barcode scanning
    @State private var isPresented = false
    @State private var isbn: String = ""
    @State private var foundBooks: BooksAPI?
    
    @Environment(\.presentationMode) private var presentationMode
    
    @State private var isShowingFilePicker = false
    @State private var selectedFileURL: URL?

    var body: some View {
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
//                .alert(isPresented: $isPresented) {
//                    Alert(title: Text("Success!"), message: Text("The ISBN has been uploaded successfully."), dismissButton: .default(Text("OK")))
//                }
        }

        .background(Color.white)
        .ignoresSafeArea()
    }
    
    private var buttonSection: some View {
        HStack(spacing: 30) {
            
            //            Button (action: {
            //
            //            }) {
            //                Text("Scan ISBN")
            //                    .frame(width: 165)
            //                    .foregroundStyle(.themeOrange)
            //            }
            //                .frame(width: 165)     //Scan ISBN
            
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
                })
            }
            
        }
        .padding(.top,30)
    }
            
//            NavigationLink(){
//                Button(action: {
//                    isPresented.toggle()
//                }, label: {
//                    Text("Scan ISBN")
//                        .foregroundStyle(.themeOrange)
//                        .padding()
//                        .overlay(){ RoundedRectangle(cornerRadius: 8)
//                                .stroke(Color.themeOrange,lineWidth: 1)
//                        }
//                    
//                })
                //            Rectangle()
                //            .frame(width: width, height: height)
                //            .overlay(
                //                Text(title)
                //                    .foregroundStyle(.themeOrange)
                //                    .background(Color.white)
                //            )
           
//                .padding(.top,17)
            
            
//            customButton(title: "Import CSV", width: 165, height: 35, destination: BarCodeScanner(isbn: $isbn , foundBooks: $foundBooks))
//                .padding(.top,17)

        
//    }
    
//    private func selectableButton(title: String) -> some View {
//        Button(action: {
//            selectedButton = title
//        }) {
//            Text(title)
//                .padding()
//                .frame(maxWidth: .infinity)
//                .background(selectedButton == title ? Color("ThemeOrange") : Color.clear)
//                .foregroundColor(selectedButton == title ? Color.white : Color("ThemeOrange"))
//                .cornerRadius(8)
//                .overlay(
//                    RoundedRectangle(cornerRadius: 8)
//                        .stroke(Color("ThemeOrange"), lineWidth: 1)
//                )
//        }
//        .padding(.top)
//        .buttonStyle(PlainButtonStyle())
//    }
    
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
            // Add book action
            updateFirestore(with: [BookRecord(isbnOfTheBook: isbn,
                                              totalNumberOfCopies: Int(numberOfCopies)!,
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
                .padding(.bottom, 50)
        }

    }
}

struct AddBookView_Previews: PreviewProvider {
    static var previews: some View {
        AddBookView()
    }
}


//struct customButton<Destination : View> : View {
//    var title : String
//    var width : Double
//    var height : Double
//    var destination : Destination
//    
//    var body: some View {
//        NavigationLink(destination : destination){
//            Button(action: {
//                isPresented.toggle()
//            }, label: {
//                Text(title)
//                    .foregroundStyle(.themeOrange)
//                    .padding()
//                    .overlay(){ RoundedRectangle(cornerRadius: 8)
//                            .stroke(Color.themeOrange,lineWidth: 1)
//                    }
//                
//            })
//            //            Rectangle()
//            //            .frame(width: width, height: height)
//            //            .overlay(
//            //                Text(title)
//            //                    .foregroundStyle(.themeOrange)
//            //                    .background(Color.white)
//            //            )
//        }
//    }
//}
