//
//  AppModel.swift
//  pushapp-lock
//
//  Created by Exequiel Tiglao on 10/26/25.
//

import Foundation

struct AppModel: Identifiable {
    let id: String
    let name: String
    let iconName: String // SF Symbol name
    var isLocked: Bool
    
    static let mockApps: [AppModel] = [
        AppModel(id: "1", name: "Instagram", iconName: "camera.fill", isLocked: false),
        AppModel(id: "2", name: "TikTok", iconName: "music.note", isLocked: false),
        AppModel(id: "3", name: "Twitter", iconName: "bird.fill", isLocked: false),
        AppModel(id: "4", name: "YouTube", iconName: "play.rectangle.fill", isLocked: false),
        AppModel(id: "5", name: "Facebook", iconName: "f.square.fill", isLocked: false),
        AppModel(id: "6", name: "Reddit", iconName: "message.fill", isLocked: false),
        AppModel(id: "7", name: "Snapchat", iconName: "camera.filters", isLocked: false),
        AppModel(id: "8", name: "Netflix", iconName: "tv.fill", isLocked: false),
    ]
}
