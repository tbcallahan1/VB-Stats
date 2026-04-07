import Foundation
import SwiftData

@Model
final class Player: Identifiable {
    var firstName: String
    var lastName: String
    var jerseyNumber: Int
    var position: String
    var team: Team?

    @Relationship(deleteRule: .cascade, inverse: \StatEntry.player)
    var stats: [StatEntry] = []

    init(firstName: String, lastName: String, jerseyNumber: Int, position: String = "") {
        self.firstName = firstName
        self.lastName = lastName
        self.jerseyNumber = jerseyNumber
        self.position = position
    }

    var fullName: String {
        "\(firstName) \(lastName)"
    }

    var displayName: String {
        "#\(jerseyNumber) \(fullName)"
    }

    // Aggregate stats across all games
    func totalStat(_ type: StatType) -> Int {
        stats.filter { $0.type == type }.count
    }

    var totalKills: Int { totalStat(.kill) }
    var totalAssists: Int { totalStat(.assist) }
    var totalBlocks: Int { totalStat(.block) }
    var totalDigs: Int { totalStat(.dig) }
    var totalAces: Int { totalStat(.ace) }
    var totalErrors: Int { totalStat(.error) }
    var totalServeReceives: Int { totalStat(.serveReceive) }
}
