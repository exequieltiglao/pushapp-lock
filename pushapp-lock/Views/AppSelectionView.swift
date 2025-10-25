//
//  AppSelectionView.swift
//  pushapp-lock
//
//  Created by Exequiel Tiglao on 10/26/25.
//

import SwiftUI

struct AppSelectionView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(appState.lockedApps) { app in
                        AppRow(app: app) {
                            appState.toggleAppLock(appId: app.id)
                        }
                    }
                } header: {
                    Text("Select apps to lock")
                } footer: {
                    Text("Locked apps will require earned time to access. Future versions will integrate with Screen Time API.")
                        .font(.caption)
                }
            }
            .navigationTitle("Apps")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        // Lock all or unlock all toggle
                        let shouldLockAll = appState.lockedApps.contains(where: { !$0.isLocked })
                        for app in appState.lockedApps {
                            if shouldLockAll && !app.isLocked {
                                appState.toggleAppLock(appId: app.id)
                            } else if !shouldLockAll && app.isLocked {
                                appState.toggleAppLock(appId: app.id)
                            }
                        }
                    }) {
                        Text(appState.lockedApps.allSatisfy { $0.isLocked } ? "Unlock All" : "Lock All")
                            .font(.subheadline)
                    }
                }
            }
        }
    }
}

struct AppRow: View {
    let app: AppModel
    let onToggle: () -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            // App Icon
            Image(systemName: app.iconName)
                .font(.system(size: 28))
                .foregroundStyle(.white)
                .frame(width: 50, height: 50)
                .background(
                    LinearGradient(
                        colors: [.blue, .purple],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .cornerRadius(12)
            
            // App Name
            Text(app.name)
                .font(.body)
            
            Spacer()
            
            // Lock Toggle
            Toggle("", isOn: Binding(
                get: { app.isLocked },
                set: { _ in onToggle() }
            ))
            .labelsHidden()
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    AppSelectionView()
        .environmentObject(AppState())
}
