//
//  ExerciseView.swift
//  pushapp-lock
//
//  Created by Exequiel Tiglao on 10/26/25.
//

import SwiftUI

struct ExerciseView: View {
    @EnvironmentObject var appState: AppState
    @State private var isExercising = false
    @State private var pushUpCount = 0
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                // Camera Preview Placeholder
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 400)
                    
                    VStack(spacing: 12) {
                        Image(systemName: "camera.fill")
                            .font(.system(size: 60))
                            .foregroundStyle(.gray)
                        
                        Text(isExercising ? "Camera Active" : "Camera Preview")
                            .font(.headline)
                            .foregroundStyle(.secondary)
                        
                        Text("VisionKit integration coming soon")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.horizontal)
                
                // Counter Display
                VStack(spacing: 8) {
                    Text("Push-ups")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    
                    Text("\(pushUpCount)")
                        .font(.system(size: 64, weight: .bold))
                        .foregroundStyle(.blue)
                }
                
                // Earned Time
                HStack(spacing: 8) {
                    Image(systemName: "clock.fill")
                        .foregroundStyle(.green)
                    
                    Text("Earned: \(pushUpCount) minutes")
                        .font(.headline)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.green.opacity(0.1))
                .cornerRadius(12)
                .padding(.horizontal)
                
                Spacer()
                
                // Control Buttons
                HStack(spacing: 16) {
                    if isExercising {
                        Button(action: {
                            stopExercise()
                        }) {
                            Text("Stop & Save")
                                .font(.headline)
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.red)
                                .cornerRadius(16)
                        }
                    } else {
                        Button(action: {
                            startExercise()
                        }) {
                            Text("Start Exercise")
                                .font(.headline)
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(16)
                        }
                    }
                    
                    // Manual increment for MVP testing
                    if isExercising {
                        Button(action: {
                            pushUpCount += 1
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 32))
                                .foregroundStyle(.blue)
                        }
                        .frame(width: 60, height: 60)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(16)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 32)
            }
            .navigationTitle("Exercise")
        }
    }
    
    private func startExercise() {
        isExercising = true
        pushUpCount = 0
        // TODO: Initialize VisionKit camera session
    }
    
    private func stopExercise() {
        isExercising = false
        appState.earnMinutes(from: pushUpCount)
        // TODO: Stop camera session
    }
}

#Preview {
    ExerciseView()
        .environmentObject(AppState())
}
