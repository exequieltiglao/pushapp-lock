//
//  OnboardingView.swift
//  pushapp-lock
//
//  Created by Exequiel Tiglao on 10/26/25.
//

import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            // App Icon
            Image(systemName: "figure.strengthtraining.traditional")
                .font(.system(size: 100))
                .foregroundStyle(.blue)
            
            // App Name
            Text("PushUnlock")
                .font(.system(size: 48, weight: .bold))
            
            // Description
            VStack(spacing: 16) {
                Text("Stop procrastinating.")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text("Earn app time by doing push-ups.\n1 push-up = 1 minute of access.")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 32)
            }
            
            Spacer()
            
            // Get Started Button
            Button(action: {
                appState.hasCompletedOnboarding = true
            }) {
                Text("Get Started")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(16)
            }
            .padding(.horizontal, 32)
            .padding(.bottom, 40)
        }
    }
}

#Preview {
    OnboardingView()
        .environmentObject(AppState())
}
