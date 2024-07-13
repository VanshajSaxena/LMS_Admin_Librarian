//
//  BookDetailsView.swift
//  LMSAdminLibrarian
//
//  Created by Nishant Sinha on 12/07/24.
//

import SwiftUI

struct BookDetailsView: View {
    let book: Book
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(radius: 10)
            
            VStack(spacing: 20) {
                Image(book.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 300)
                    .padding(.bottom)
                
                Text(book.title)
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                
                Text(book.description)
                    .font(.system(size: 24))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .lineLimit(3)
                    .truncationMode(.tail)
                
                Text("Language: \(book.language)")
                    .font(.system(size: 25))
                    .fontWeight(.bold)
                    .foregroundColor(Color("ThemeOrange"))
                    .padding(.top)
            }
            .padding()
        }
        .frame(width: 460, height: 660)
        .padding()
    }
}

struct Book: Identifiable {
    let id = UUID()
    let imageName: String
    let title: String
    let description: String
    let language: String
}

struct BookDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        BookDetailsView(book: Book(
            imageName: "DemiPic",
            title: "The Three Mustekeers",
            description: "A book about two lovers and the struggles that they face to meet each other and spend their lives together. This is a longer description to demonstrate the truncation feature.",
            language: "Eng"
        ))
    }
}
