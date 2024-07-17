//
//  UploadSuccessfulView.swift
//  LMSAdminLibrarian
//
//  Created by Nishant Sinha on 12/07/24.
//

import SwiftUI

struct UploadSuccessfulView: View {
    @State private var isUploaded = false
    let fileData: FileData
    
    var body: some View {
        VStack {
            Spacer()
            VStack(spacing: 40) {
                VStack(spacing: 20) {
                    Text(isUploaded ? "Upload Successful !" : "Selected File")
                        .font(.title)
                        .font(.system(size: 35))
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                    
                    if isUploaded {
                        Image(systemName: "checkmark.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 200, height: 150)
                            .foregroundColor(.green)
                            .padding(.top, 60)
                    } else {
                        Text("Below is the file that you have selected")
                            .font(.body)
                            .font(.system(size: 30))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                }.padding(.bottom, 40)
                
                VStack(spacing: 90) {
                    if !isUploaded {
                        HStack {
                            Image(systemName: "doc.text.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 70, height: 70)
                                .foregroundColor(.green)
                            
                            VStack(alignment: .leading, spacing: 5) {
                                Text(fileData.fileName)
                                    .font(.system(size: 20))
                                    .font(.body)
                                    .fontWeight(.bold)
                                
                                Text("\(fileData.fileSize) mb")
                                    .font(.system(size: 20))
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                    }
                    
                    Button(action: {
                        withAnimation {
                            isUploaded.toggle()
                        }
                    }) {
                        Text(isUploaded ? "Done" : "Upload")
                            .font(.body)
                            .fontWeight(.bold)
                            .padding()
                            .frame(width: 150, height: 50)
                            .background(Color("ThemeOrange"))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                }
            }
            .padding()
            .frame(width: 500, height: 550)
            .background(Color.white)
            .cornerRadius(20)
            .shadow(radius: 10)
            .padding()
            Spacer()
        }
    }
}

struct FileData {
    let fileName: String
    let fileSize: String
}

struct UploadSuccessfulView_Previews: PreviewProvider {
    static var previews: some View {
        UploadSuccessfulView(fileData: FileData(
            fileName: "All Book Details.csv",
            fileSize: "50"
        ))
    }
}
