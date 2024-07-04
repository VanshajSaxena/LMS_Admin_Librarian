//
//  AddBookView.swift
//  inventory
//
//  Created by Ayush Sharma on 04/07/24.
//

import SwiftUI

struct AddBookView: View {
    @State private var name: String = ""
    @State private var author: String = ""
    @State private var genre: String = ""
    @State private var pages: String = ""
    @State private var language: String = ""
    @State private var column: String = ""
    @State private var shelf: String = ""
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                HStack {
                    Button(action: {
                        // Action for Import ISBN
                    }) {
                        Text("Import ISBN")
                            .frame(minWidth: 100)
                            .padding()
                            .background(Color.white)
                            .foregroundColor(.orange)
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.orange, lineWidth: 1)
                            )
                    }
                    Button(action: {
                        // Action for Import CSV
                    }) {
                        Text("Import CSV")
                            .frame(minWidth: 100)
                            .padding()
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
                
                Form {
                    Section(header: Text("Add Book").font(.headline)) {
                        TextField("Enter the name of the book", text: $name)
                            .padding()
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray, lineWidth: 1)
                            )
                        TextField("Enter the name of the Author", text: $author)
                            .padding()
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray, lineWidth: 1)
                            )
                        TextField("Enter the Genre", text: $genre)
                            .padding()
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray, lineWidth: 1)
                            )
                        TextField("Enter the no of pages", text: $pages)
                            .padding()
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray, lineWidth: 1)
                            )
                        TextField("Enter the language of the book", text: $language)
                            .padding()
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray, lineWidth: 1)
                            )
                        TextField("Enter the column no", text: $column)
                            .padding()
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray, lineWidth: 1)
                            )
                        TextField("Enter the shelf no", text: $shelf)
                            .padding()
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray, lineWidth: 1)
                            )
                    }
                }
                .frame(maxHeight: .infinity)
                
                Button(action: {
                    // Action for Done button
                    // Save the data and navigate back
                }) {
                    Text("Done")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding()
            }
            .padding()
            .navigationBarTitle("Add Book", displayMode: .inline)
        }
    }
}

struct AddBookView_Previews: PreviewProvider {
    static var previews: some View {
        AddBookView()
    }
}
