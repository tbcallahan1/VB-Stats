import Foundation
import SwiftData

@Model
final class Team: Identifiable {
    var name: String
    var abbreviation: String
    var createdAt: Date

    @Relationship(deleteRule: .cascade, inverse: \Player.team)
    var players: [Player] = []

    @Relationship(deleteRule: .cascade, inverse: \Game.homeTeam)
    var homeGames: [Game] = []

    init(name: String, abbreviation: String = "") {
        self.name = name
        self.abbreviation = abbreviation
        self.createdAt = Date()
    }

    var totalWins: Int {
        homeGames.filter { $0.homeScore > $0.awayScore && $0.isCompleted }.count
    }

    var totalLosses: Int {
        homeGames.filter { $0.homeScore < $0.awayScore && $0.isCompleted }.count
    }

    var record: String {
        "\(totalWins)-\(totalLosses)"
    }
}
