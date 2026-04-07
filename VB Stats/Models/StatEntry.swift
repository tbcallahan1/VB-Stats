import Foundation
import SwiftData

enum StatType: String, Codable, CaseIterable, Identifiable {
    case kill
    case assist
    case block
    case dig
    case ace
    case error
    case serveReceive

    var id: String { rawValue }

    var label: String {
        switch self {
        case .kill: "Kill"
        case .assist: "Assist"
        case .block: "Block"
        case .dig: "Dig"
        case .ace: "Ace"
        case .error: "Error"
        case .serveReceive: "Serve Receive"
        }
    }

    var icon: String {
        switch self {
        case .kill: "flame.fill"
        case .assist: "hands.clap.fill"
        case .block: "hand.raised.fill"
        case .dig: "arrow.down.to.line"
        case .ace: "star.fill"
        case .error: "xmark.circle.fill"
        case .serveReceive: "arrow.uturn.up"
        }
    }
}

@Model
final class StatEntry: Identifiable {
    var type: StatType
    var timestamp: Date
    var set: Int
    var player: Player?
    var game: Game?

    init(type: StatType, set: Int = 1) {
        self.type = type
        self.timestamp = Date()
        self.set = set
    }
}
