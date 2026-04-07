import SwiftUI

struct GameDetailView: View {
    @Bindable var game: Game

    var body: some View {
        List {
            Section("Score") {
                HStack {
                    VStack {
                        Text(game.homeTeam?.name ?? "Home")
                            .font(.headline)
                        Text("\(game.homeScore)")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                    }
                    .frame(maxWidth: .infinity)

                    Text("vs")
                        .font(.title2)
                        .foregroundStyle(.secondary)

                    VStack {
                        Text(game.opponent)
                            .font(.headline)
                        Text("\(game.awayScore)")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding(.vertical, 8)
            }

            if !game.setScores.isEmpty {
                Section("Sets") {
                    ForEach(Array(game.setScores.enumerated()), id: \.offset) { index, score in
                        HStack {
                            Text("Set \(index + 1)")
                            Spacer()
                            Text("\(score.home) - \(score.away)")
                                .fontWeight(.medium)
                        }
                    }
                }
            }

            if !game.isCompleted {
                Section {
                    NavigationLink("Live Scoring", destination: LiveGameView(game: game))
                        .font(.headline)
                        .foregroundStyle(.blue)
                }
            }

            Section("Game Stats") {
                let gameStats = game.statEntries
                if gameStats.isEmpty {
                    Text("No stats recorded yet.")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(StatType.allCases) { type in
                        let count = gameStats.filter { $0.type == type }.count
                        if count > 0 {
                            HStack {
                                Image(systemName: type.icon)
                                    .foregroundStyle(.blue)
                                Text(type.label)
                                Spacer()
                                Text("\(count)")
                                    .fontWeight(.semibold)
                            }
                        }
                    }
                }
            }

            if !game.notes.isEmpty {
                Section("Notes") {
                    Text(game.notes)
                }
            }
        }
        .navigationTitle("vs \(game.opponent)")
    }
}
