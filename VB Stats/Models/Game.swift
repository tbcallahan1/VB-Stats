import Foundation
import SwiftData

@Model
final class Game: Identifiable {
    var date: Date
    var opponent: String
    var homeScore: Int
    var awayScore: Int
    var currentSet: Int
    var isCompleted: Bool
    var notes: String
    var homeTeam: Team?

    @Relationship(deleteRule: .cascade, inverse: \StatEntry.game)
    var statEntries: [StatEntry] = []

    // Store set scores as comma-separated "homeScore-awayScore" pairs
    var setScoresRaw: String

    init(opponent: String, date: Date = Date()) {
        self.date = date
        self.opponent = opponent
        self.homeScore = 0
        self.awayScore = 0
        self.currentSet = 1
        self.isCompleted = false
        self.notes = ""
        self.setScoresRaw = ""
    }

    var setScores: [(home: Int, away: Int)] {
        guard !setScoresRaw.isEmpty else { return [] }
        return setScoresRaw.split(separator: ",").compactMap { pair in
            let parts = pair.split(separator: "-")
            guard parts.count == 2,
                  let h = Int(parts[0]),
                  let a = Int(parts[1]) else { return nil }
            return (h, a)
        }
    }

    func addSetScore(home: Int, away: Int) {
        if setScoresRaw.isEmpty {
            setScoresRaw = "\(home)-\(away)"
        } else {
            setScoresRaw += ",\(home)-\(away)"
        }
    }

    var scoreDisplay: String {
        "\(homeScore)-\(awayScore)"
    }

    var dateFormatted: String {
        date.formatted(date: .abbreviated, time: .omitted)
    }
}
