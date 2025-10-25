//
//  ContentView.swift
//  pushapp-lock
//
//  Created by Exequiel Tiglao on 10/26/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        Group {
            if !appState.hasCompletedOnboarding {
                OnboardingView()
            } else {
                MainTabView()
            }
        }
    }
}

struct MainTabView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        TabView {
            DashboardView()
                .tabItem {
                    Label("Dashboard", systemImage: "house.fill")
                }
            
            ExerciseView()
                .tabItem {
                    Label("Exercise", systemImage: "figure.strengthtraining.traditional")
                }
            
            AppSelectionView()
                .tabItem {
                    Label("Apps", systemImage: "square.grid.2x2.fill")
                }
        }
        .sheet(isPresented: $appState.isTimerActive) {
            TimerView()
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AppState())
}
