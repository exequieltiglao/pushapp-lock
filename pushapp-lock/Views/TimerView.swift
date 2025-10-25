//
//  TimerView.swift
//  pushapp-lock
//
//  Created by Exequiel Tiglao on 10/26/25.
//

import SwiftUI

struct TimerView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss
    @State private var timeRemaining: Int = 0
    @State private var timer: Timer?
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 40) {
                Spacer()
                
                // Timer Display
                VStack(spacing: 16) {
                    Text("Time Remaining")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                    
                    Text(timeString(from: timeRemaining))
                        .font(.system(size: 72, weight: .bold, design: .rounded))
                        .monospacedDigit()
                        .foregroundStyle(timeRemaining < 60 ? .red : .primary)
                }
                
                // Progress Ring
                ZStack {
                    Circle()
                        .stroke(Color.gray.opacity(0.2), lineWidth: 20)
                        .frame(width: 200, height: 200)
                    
                    Circle()
                        .trim(from: 0, to: progress)
                        .stroke(
                            timeRemaining < 60 ? Color.red : Color.blue,
                            style: StrokeStyle(lineWidth: 20, lineCap: .round)
                        )
                        .frame(width: 200, height: 200)
                        .rotationEffect(.degrees(-90))
                        .animation(.linear(duration: 1), value: progress)
                }
                
                // Info
                if timeRemaining == 0 {
                    VStack(spacing: 12) {
                        Text("Time's up!")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        Text("Do more push-ups to continue")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
                
                Spacer()
                
                // Actions
                VStack(spacing: 12) {
                    Button(action: {
                        stopTimer()
                        dismiss()
                    }) {
                        Text("Close")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(16)
                    }
                    
                    if timeRemaining == 0 {
                        Button(action: {
                            stopTimer()
                            dismiss()
                            // Navigate to exercise tab would go here
                        }) {
                            Text("Earn More Time")
                                .font(.headline)
                                .foregroundStyle(.blue)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue.opacity(0.1))
                                .cornerRadius(16)
                        }
                    }
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 40)
            }
            .navigationBarTitleDisplayMode(.inline)
            .interactiveDismissDisabled(timeRemaining > 0)
        }
        .onAppear {
            startTimer()
        }
        .onDisappear {
            stopTimer()
        }
    }
    
    private var progress: CGFloat {
        let total = appState.minutesLeft * 60
        guard total > 0 else { return 0 }
        return CGFloat(timeRemaining) / CGFloat(total)
    }
    
    private func startTimer() {
        timeRemaining = appState.currentTimerSeconds
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                stopTimer()
            }
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
        appState.currentTimerSeconds = timeRemaining
        appState.minutesLeft = timeRemaining / 60
    }
    
    private func timeString(from seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%02d:%02d", minutes, remainingSeconds)
    }
}

#Preview {
    TimerView()
        .environmentObject({
            let state = AppState()
            state.minutesLeft = 5
            state.currentTimerSeconds = 300
            state.isTimerActive = true
            return state
        }())
}
