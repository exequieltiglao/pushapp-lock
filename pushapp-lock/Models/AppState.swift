//
//  AppState.swift
//  pushapp-lock
//
//  Created by Exequiel Tiglao on 10/26/25.
//

import Foundation
import SwiftUI

class AppState: ObservableObject {
    @Published var hasCompletedOnboarding: Bool = false
    @Published var minutesLeft: Int = 0
    @Published var pushUpsToday: Int = 0
    @Published var lockedApps: [AppModel] = []
    @Published var isTimerActive: Bool = false
    @Published var currentTimerSeconds: Int = 0
    
    init() {
        // Load mock apps for MVP
        self.lockedApps = AppModel.mockApps
    }
    
    func earnMinutes(from pushUps: Int) {
        minutesLeft += pushUps
        pushUpsToday += pushUps
    }
    
    func startTimer() {
        guard minutesLeft > 0 else { return }
        isTimerActive = true
        currentTimerSeconds = minutesLeft * 60
    }
    
    func stopTimer() {
        isTimerActive = false
        minutesLeft = currentTimerSeconds / 60
    }
    
    func toggleAppLock(appId: String) {
        if let index = lockedApps.firstIndex(where: { $0.id == appId }) {
            lockedApps[index].isLocked.toggle()
        }
    }
}
