//
//  PushUpDetector.swift
//  pushapp-lock
//
//  Created by Exequiel Tiglao on 10/26/25.
//

import Vision
import CoreGraphics

class PushUpDetector: ObservableObject {
    @Published var pushUpCount = 0
    @Published var currentPosition: PushUpPosition = .unknown
    
    private var isInDownPosition = false
    private var hasReachedUpPosition = true // Start in up position
    
    // Angle thresholds
    private let downPositionAngle: CGFloat = 120 // Elbow angle when down
    private let upPositionAngle: CGFloat = 160   // Elbow angle when up
    
    func analyzePose(_ observation: VNHumanBodyPoseObservation) {
        guard let leftElbowAngle = getElbowAngle(observation: observation, side: .left),
              let rightElbowAngle = getElbowAngle(observation: observation, side: .right) else {
            return
        }
        
        let averageElbowAngle = (leftElbowAngle + rightElbowAngle) / 2
        
        // Detect push-up phases
        if averageElbowAngle < downPositionAngle && hasReachedUpPosition {
            // Down position detected
            isInDownPosition = true
            hasReachedUpPosition = false
            currentPosition = .down
        } else if averageElbowAngle > upPositionAngle && isInDownPosition {
            // Up position detected - complete push-up
            pushUpCount += 1
            print("💪 PUSH-UP COUNTED! Total: \(pushUpCount)")
            isInDownPosition = false
            hasReachedUpPosition = true
            currentPosition = .up
        } else if averageElbowAngle >= downPositionAngle && averageElbowAngle <= upPositionAngle {
            currentPosition = .middle
        }
    }
    
    private func getElbowAngle(observation: VNHumanBodyPoseObservation, side: BodySide) -> CGFloat? {
        guard let shoulder = try? observation.recognizedPoint(side == .left ? .leftShoulder : .rightShoulder),
              let elbow = try? observation.recognizedPoint(side == .left ? .leftElbow : .rightElbow),
              let wrist = try? observation.recognizedPoint(side == .left ? .leftWrist : .rightWrist),
              shoulder.confidence > 0.3 && elbow.confidence > 0.3 && wrist.confidence > 0.3 else {
            return nil
        }
        
        return calculateAngle(
            point1: CGPoint(x: shoulder.location.x, y: shoulder.location.y),
            point2: CGPoint(x: elbow.location.x, y: elbow.location.y),
            point3: CGPoint(x: wrist.location.x, y: wrist.location.y)
        )
    }
    
    private func calculateAngle(point1: CGPoint, point2: CGPoint, point3: CGPoint) -> CGFloat {
        let vector1 = CGPoint(x: point1.x - point2.x, y: point1.y - point2.y)
        let vector2 = CGPoint(x: point3.x - point2.x, y: point3.y - point2.y)
        
        let dotProduct = vector1.x * vector2.x + vector1.y * vector2.y
        let magnitude1 = sqrt(vector1.x * vector1.x + vector1.y * vector1.y)
        let magnitude2 = sqrt(vector2.x * vector2.x + vector2.y * vector2.y)
        
        let cosine = dotProduct / (magnitude1 * magnitude2)
        let angleInRadians = acos(max(-1, min(1, cosine)))
        let angleInDegrees = angleInRadians * 180 / .pi
        
        return angleInDegrees
    }
    
    func reset() {
        pushUpCount = 0
        isInDownPosition = false
        hasReachedUpPosition = true
        currentPosition = .unknown
    }
}

// MARK: - Supporting Types
enum BodySide {
    case left, right
}

enum PushUpPosition {
    case up, middle, down, unknown
    
    var description: String {
        switch self {
        case .up: return "Up"
        case .middle: return "Middle"
        case .down: return "Down"
        case .unknown: return "Ready"
        }
    }
    
    var color: String {
        switch self {
        case .up: return "green"
        case .middle: return "orange"
        case .down: return "blue"
        case .unknown: return "gray"
        }
    }
}
