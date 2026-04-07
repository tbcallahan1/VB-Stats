import SwiftUI
import SwiftData

struct GamesListView: View {
    @Query(sort: \Game.date, order: .reverse) private var games: [Game]

    var body: some View {
        NavigationStack {
            List {
                if games.isEmpty {
                    ContentUnavailableView(
                        "No Games",
                        systemImage: "sportscourt.fill",
                        description: Text("Games will appear here once added from a team.")
                    )
                }
                ForEach(games, id: \Game.id) { game in
                    NavigationLink(destination: GameDetailView(game: game)) {
                        GameRowView(game: game)
                    }
                }
            }
            .navigationTitle("Games")
        }
    }
}

struct GameRowView: View {
    let game: Game

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("\(game.homeTeam?.name ?? "Team") vs \(game.opponent)")
                    .font(.headline)
                Text(game.dateFormatted)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text(game.scoreDisplay)
                    .font(.title3)
                    .fontWeight(.semibold)
                Text(game.isCompleted ? "Final" : "In Progress")
                    .font(.caption2)
                    .foregroundStyle(game.isCompleted ? .secondary : .orange)
            }
        }
        .padding(.vertical, 4)
    }
}
