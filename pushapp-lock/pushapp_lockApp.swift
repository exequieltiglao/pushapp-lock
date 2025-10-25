//
//  pushapp_lockApp.swift
//  pushapp-lock
//
//  Created by Exequiel Tiglao on 10/26/25.
//

import SwiftUI

@main
struct pushapp_lockApp: App {
    @StateObject private var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
        }
    }
}
