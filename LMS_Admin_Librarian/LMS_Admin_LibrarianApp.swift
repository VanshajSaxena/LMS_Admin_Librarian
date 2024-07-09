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
struct LMS_Admin_LibrarianApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            LoginView()
            
        }
    }
}
