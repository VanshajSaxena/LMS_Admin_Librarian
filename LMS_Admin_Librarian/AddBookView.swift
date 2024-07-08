import SwiftUI

struct AddBookView: View {
    @State private var isbnNumber: String = ""
    @State private var numberOfCopies: String = ""
    @State private var column: String = ""
    @State private var shelf: String = ""
    @State private var selectedButton: String? = nil
    
    var body: some View {
        VStack(spacing: 30) {
            buttonSection
            
            VStack {
                Text("Add Book")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.horizontal, 50)
            }
            
            ScrollView {
                formSection
                    .padding(.horizontal, 50)
            }
            
            doneButton
                .padding(.horizontal, 250)
                .padding(.top, 30)
        }
        .background(Color("BackgroundColor").edgesIgnoringSafeArea(.all))
        .ignoresSafeArea()
    }
    
    private var buttonSection: some View {
        HStack(spacing: 30) {
            selectableButton(title: "Scan ISBN").frame(width: 165)     //Scan ISBN
            Rectangle().frame(width: 1, height: 70).foregroundColor(Color("ThemeOrange")).padding(.top, 20)
            selectableButton(title: "Import CSV").frame(width: 165)   //Import CSV
        }
        .padding(.horizontal, 200)
    }
    
    private func selectableButton(title: String) -> some View {
        Button(action: {
            selectedButton = title
        }) {
            Text(title)
                .padding()
                .frame(maxWidth: .infinity)
                .background(selectedButton == title ? Color("ThemeOrange") : Color.clear)
                .foregroundColor(selectedButton == title ? Color.white : Color("ThemeOrange"))
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color("ThemeOrange"), lineWidth: 1)
                )
        }
        .padding(.top)
        .buttonStyle(PlainButtonStyle())
    }
    
    private var formSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            formField(title: "ISBN Number", text: $isbnNumber, placeholder: "Enter the ISBN number")
            formField(title: "No of Copies", text: $numberOfCopies, placeholder: "Enter the number of copies")
            formField(title: "Column", text: $column, placeholder: "Enter the column")
            formField(title: "Shelf", text: $shelf, placeholder: "Enter the shelf")
        }
    }
    
    private func formField(title: String, text: Binding<String>, placeholder: String) -> some View {
        VStack(alignment: .leading) {
            Text(title)
                .padding(.leading, 20)
                .font(.headline)
                .foregroundColor(Color("ThemeOrange"))
            TextField(placeholder, text: text)
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
            // Add done action
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
