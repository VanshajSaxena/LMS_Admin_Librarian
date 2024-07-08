//
//  ContentView.swift
//  BookInfo
//
//  Created by Brian Advent on 15.10.20.
//

import SwiftUI
import UIKit

struct BookDetailsView: View {
    
    @State private var isPresented = false
    @State private var isbn: String?
    @State private var foundBooks: Books?
    
    
    
    var body: some View {
        
        let bookToUse = BookMetaData(title: foundBooks?.items.first?.volumeInfo.title ?? "Title",
                                     authors: foundBooks?.items.first?.volumeInfo.authors.first ?? "Author",
                                     publishedDate: foundBooks?.items.first?.volumeInfo.authors.first ?? "Author",
                                     pageCount: "\(foundBooks?.items.first?.volumeInfo.pageCount ?? 0) Pages",
                                     language: foundBooks?.items.first?.volumeInfo.language ?? "Language",
                                     imageLinks: foundBooks?.items.first?.volumeInfo.imageLinks.thumbnail ?? "",
                                     isbn: "ISBN: \(isbn ?? "")")
        
        NavigationView {
            Form {
                Section(header: Text("ABOUT THIS BOOK")){
                    RemoteImage(url: bookToUse.imageLinks)
                                .frame(width: 200, height: 300)
                    
                    Text(bookToUse.title)
                    Text(bookToUse.authors)
                }
                Section(header: Text("ADDITIONAL INFO")){
                    Text(bookToUse.publishedDate)
                    Text(bookToUse.pageCount)
                    Text(bookToUse.language)
                    Text("ISBN: \(isbn ?? "")")
                }
                
            }.navigationBarTitle("Books")
                .navigationBarItems(trailing: Button(action: {
                    self.isPresented.toggle()
                }) {
                    Image(systemName: "barcode.viewfinder")
                }
                    .sheet(isPresented: $isPresented) {
                    BarCodeScanner(isbn: $isbn,
                                   foundBooks: $foundBooks)
                }
                )
            
        }
        
    }
}

struct BookDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        BookDetailsView()
    }
}

struct RemoteImage: View {
    let url: String
    
    var body: some View {
        AsyncImage(url: URL(string: url)) { phase in
            switch phase {
            case .success(let image):
                image.resizable().aspectRatio(contentMode: .fit)
            case .failure:
                Image(systemName: "photo").foregroundColor(.gray)
            case .empty:
                ProgressView()
            @unknown default:
                EmptyView()
            }
        }
    }
}
