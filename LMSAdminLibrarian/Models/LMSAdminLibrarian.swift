//
//  LMS_Admin_LibrarianApp.swift
//  LMS_Admin_Librarian
//
//  Created by Aida Sharon Bruce on 03/07/24.
//

import SwiftUI
import FirebaseCore
import FirebaseDatabase
import FirebaseAuth

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct LMSAdminLibrarian: App {
    @StateObject private var authViewModel = AuthViewModel()
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authViewModel)
                .onAppear {
                    checkAuthentication()
                }
        }
    }
    
    
    private func checkAuthentication() {
        if authViewModel.isAuthenticated, let userTypeRaw = authViewModel.storedUserType, let userType = UserType(rawValue: userTypeRaw) {
            authViewModel.userType = userType
        }
    }
    
}
