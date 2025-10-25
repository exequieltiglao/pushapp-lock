//
//  ExerciseView.swift
//  pushapp-lock
//
//  Created by Exequiel Tiglao on 10/26/25.
//

import SwiftUI

struct ExerciseView: View {
    @EnvironmentObject var appState: AppState
    @StateObject private var cameraManager = CameraManager()
    @StateObject private var pushUpDetector = PushUpDetector()
    @State private var isExercising = false
    @State private var showError = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                // Camera Preview
                ZStack {
                    if cameraManager.isSessionRunning {
                        CameraPreviewView(previewLayer: cameraManager.previewLayer)
                            .frame(height: 400)
                            .cornerRadius(20)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(positionColor, lineWidth: 4)
                            )
                    } else {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 400)
                            .overlay(
                                VStack(spacing: 12) {
                                    Image(systemName: "camera.fill")
                                        .font(.system(size: 60))
                                        .foregroundStyle(.gray)
                                    
                                    Text("Camera Ready")
                                        .font(.headline)
                                        .foregroundStyle(.secondary)
                                    
                                    Text("Tap Start to begin")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            )
                    }
                    
                    // Position Indicator
                    if isExercising {
                        VStack {
                            HStack {
                                Spacer()
                                Text(pushUpDetector.currentPosition.description)
                                    .font(.headline)
                                    .foregroundStyle(.white)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(positionColor.opacity(0.8))
                                    .cornerRadius(20)
                                    .padding()
                            }
                            Spacer()
                        }
                    }
                }
                .padding(.horizontal)
                
                // Counter Display
                VStack(spacing: 8) {
                    Text("Push-ups")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    
                    Text("\(pushUpDetector.pushUpCount)")
                        .font(.system(size: 64, weight: .bold))
                        .foregroundStyle(.blue)
                        .contentTransition(.numericText())
                }
                
                // Earned Time
                HStack(spacing: 8) {
                    Image(systemName: "clock.fill")
                        .foregroundStyle(.green)
                    
                    Text("Earned: \(pushUpDetector.pushUpCount) minutes")
                        .font(.headline)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.green.opacity(0.1))
                .cornerRadius(12)
                .padding(.horizontal)
                
                Spacer()
                
                // Control Buttons
                Button(action: {
                    if isExercising {
                        stopExercise()
                    } else {
                        Task {
                            await startExercise()
                        }
                    }
                }) {
                    Text(isExercising ? "Stop & Save" : "Start Exercise")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(isExercising ? Color.red : Color.blue)
                        .cornerRadius(16)
                }
                .padding(.horizontal)
                .padding(.bottom, 32)
            }
            .navigationTitle("Exercise")
            .task {
                await cameraManager.setupCamera()
            }
            .onDisappear {
                cameraManager.stopSession()
            }
            .alert("Camera Error", isPresented: $showError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(cameraManager.error?.localizedDescription ?? "Unknown error")
            }
        }
    }
    
    private var positionColor: Color {
        switch pushUpDetector.currentPosition {
        case .up: return .green
        case .middle: return .orange
        case .down: return .blue
        case .unknown: return .gray
        }
    }
    
    private func startExercise() async {
        pushUpDetector.reset()
        
        // Setup pose detection callback
        cameraManager.onPoseDetected = { observation in
            pushUpDetector.analyzePose(observation)
        }
        
        cameraManager.startSession()
        isExercising = true
        
        if cameraManager.error != nil {
            showError = true
        }
    }
    
    private func stopExercise() {
        cameraManager.stopSession()
        isExercising = false
        appState.earnMinutes(from: pushUpDetector.pushUpCount)
        cameraManager.onPoseDetected = nil
    }
}

#Preview {
    ExerciseView()
        .environmentObject(AppState())
}
