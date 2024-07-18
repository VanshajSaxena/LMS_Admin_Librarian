////
////  NotificationPopoverView.swift
////  LMSAdminLibrarian
////
////  Created by Mahak garg on 17/07/24.
////
//
//import SwiftUI
//
//struct NotificationPopoverView: View {
//    @ObservedObject var requestRepo = RequestRepository()
//    @State private var processingRequestId: String?
//    var body: some View {
//        VStack(spacing: 20) {
//            HStack {
//                Text("Notifications")
//                    .font(.title2)
//                    .fontWeight(.bold)
//                Spacer()
//                Button(action: {
//                    // Action to close popover
//                }) {
//                    Image(systemName: "xmark")
//                        .foregroundColor(.gray)
//                        .padding()
//                        .background(Color("BackgroundColor"))
//                        .clipShape(Circle())
//                }
//            }
//            
//            HStack(alignment: .top, spacing: 10) {
//                Image(systemName: "person.circle.fill")
//                    .resizable()
//                    .frame(width: 50, height: 50)
//                    .foregroundColor(Color("ThemeOrange"))
//                
//                VStack(alignment: .leading, spacing: 5) {
//                    Text("Rohit Singh")
//                        .font(.headline)
//                        .fontWeight(.bold)
//                    Text("requested to organize a new campaign for the month of December")
//                        .font(.subheadline)
//                        .foregroundColor(.gray)
//                }
//            }
//            
//            
//            
//            HStack {
//                Button(action: {
//                    // Approve action
//                }) {
//                    Text("Approve")
//                        .padding()
//                        .frame(maxWidth: .infinity)
//                        .background(Color("ThemeOrange"))
//                        .foregroundColor(.white)
//                        .clipShape(RoundedRectangle(cornerRadius: 10))
//                }
//                
//                Button(action: {
//                    // Deny action
//                }) {
//                    Text("Deny")
//                        .padding()
//                        .frame(maxWidth: .infinity)
//                        .background(Color.white)
//                        .foregroundColor(Color("ThemeOrange"))
//                        .clipShape(RoundedRectangle(cornerRadius: 10))
//                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color("ThemeOrange"), lineWidth: 1))
//                }
//            }
//            
//            HStack {
//                Text("Project")
//                    .font(.caption)
//                    .foregroundColor(.gray)
//                Spacer()
//                Text(". 5 min ago")
//                    .font(.caption)
//                    .foregroundColor(.gray)
//            }
//        }
//        .padding()
//        .background(Color.white)
//        .clipShape(RoundedRectangle(cornerRadius: 20))
//        .shadow(radius: 10)
//        .frame(width: 350) // Adjust the width as needed
//    }
//}
//
//
//#Preview {
//    NotificationPopoverView()
//}
