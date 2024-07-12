//
//  ContentView.swift
//  sidebarviewdemo
//
//  Created by Mahak garg on 10/07/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    var body: some View {
        Group {
            if authViewModel.isAuthenticated {
                switch authViewModel.userType {
                case .admin:
                    AdminMainView()
                case .librarian:
                    LibrarianMainView()
                default:
                    LoginView()
                }
            } else {
                LoginView()
            }
        }
    }
}


#Preview {
    ContentView()
}
