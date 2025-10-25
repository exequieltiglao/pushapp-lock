//
//  DashboardView.swift
//  pushapp-lock
//
//  Created by Exequiel Tiglao on 10/26/25.
//

import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 8) {
                        Text("Your Progress")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Text("Keep pushing!")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.top, 20)
                    
                    // Stats Cards
                    VStack(spacing: 16) {
                        StatCard(
                            title: "Minutes Left",
                            value: "\(appState.minutesLeft)",
                            icon: "clock.fill",
                            color: .blue
                        )
                        
                        StatCard(
                            title: "Push-ups Today",
                            value: "\(appState.pushUpsToday)",
                            icon: "figure.strengthtraining.traditional",
                            color: .green
                        )
                        
                        StatCard(
                            title: "Apps Locked",
                            value: "\(appState.lockedApps.filter { $0.isLocked }.count)",
                            icon: "lock.fill",
                            color: .orange
                        )
                    }
                    .padding(.horizontal)
                    
                    // Quick Action
                    if appState.minutesLeft == 0 {
                        VStack(spacing: 12) {
                            Text("No time left!")
                                .font(.headline)
                            
                            Text("Do some push-ups to earn access")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(16)
                        .padding(.horizontal)
                    }
                    
                    Spacer()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 32))
                .foregroundStyle(color)
                .frame(width: 60, height: 60)
                .background(color.opacity(0.1))
                .cornerRadius(12)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                Text(value)
                    .font(.system(size: 36, weight: .bold))
            }
            
            Spacer()
        }
        .padding()
        .background(Color(uiColor: .systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
}

#Preview {
    DashboardView()
        .environmentObject(AppState())
}
