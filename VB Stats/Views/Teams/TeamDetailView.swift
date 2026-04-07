import SwiftUI
import SwiftData

struct TeamDetailView: View {
    @Bindable var team: Team
    @State private var showingAddPlayer = false
    @State private var showingAddGame = false
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        List {
            Section("Record") {
                HStack {
                    Label("Wins", systemImage: "checkmark.circle.fill")
                        .foregroundStyle(.green)
                    Spacer()
                    Text("\(team.totalWins)")
                }
                HStack {
                    Label("Losses", systemImage: "xmark.circle.fill")
                        .foregroundStyle(.red)
                    Spacer()
                    Text("\(team.totalLosses)")
                }
            }

            Section("Players (\(team.players.count))") {
                ForEach(team.players.sorted(by: { $0.jerseyNumber < $1.jerseyNumber }), id: \.id) { player in
                    NavigationLink(destination: PlayerDetailView(player: player)) {
                        HStack {
                            Text("#\(player.jerseyNumber)")
                                .font(.headline)
                                .frame(width: 44)
                            VStack(alignment: .leading) {
                                Text(player.fullName)
                                    .font(.body)
                                if !player.position.isEmpty {
                                    Text(player.position)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                    }
                }
                .onDelete(perform: deletePlayers)

                Button(action: { showingAddPlayer = true }) {
                    Label("Add Player", systemImage: "plus")
                }
            }

            Section("Games (\(team.homeGames.count))") {
                ForEach(team.homeGames.sorted(by: { $0.date > $1.date }), id: \.id) { game in
                    NavigationLink(destination: GameDetailView(game: game)) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("vs \(game.opponent)")
                                    .font(.headline)
                                Text(game.dateFormatted)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            Text(game.scoreDisplay)
                                .font(.title3)
                                .fontWeight(.semibold)
                            if game.isCompleted {
                                Image(systemName: game.homeScore > game.awayScore ? "checkmark.circle.fill" : "xmark.circle.fill")
                                    .foregroundStyle(game.homeScore > game.awayScore ? .green : .red)
                            }
                        }
                    }
                }

                Button(action: { showingAddGame = true }) {
                    Label("Add Game", systemImage: "plus")
                }
            }
        }
        .navigationTitle(team.name)
        .sheet(isPresented: $showingAddPlayer) {
            AddPlayerView(team: team)
        }
        .sheet(isPresented: $showingAddGame) {
            AddGameView(team: team)
        }
    }

    private func deletePlayers(at offsets: IndexSet) {
        let sorted = team.players.sorted(by: { $0.jerseyNumber < $1.jerseyNumber })
        for index in offsets {
            modelContext.delete(sorted[index])
        }
    }
}
