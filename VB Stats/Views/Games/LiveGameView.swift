import SwiftUI
import SwiftData

struct LiveGameView: View {
    @Bindable var game: Game
    @Environment(\.modelContext) private var modelContext
    @State private var selectedPlayer: Player?
    @State private var showEndGameAlert = false

    private var players: [Player] {
        (game.homeTeam?.players ?? []).sorted { $0.jerseyNumber < $1.jerseyNumber }
    }

    var body: some View {
        VStack(spacing: 0) {
            // Scoreboard
            scoreboardSection

            Divider()

            // Player selector
            playerSelector

            Divider()

            // Stat buttons
            statButtons
        }
        .navigationTitle("Set \(game.currentSet)")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Menu {
                    Button("End Set") { endSet() }
                    Button("End Game", role: .destructive) { showEndGameAlert = true }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
        .alert("End Game?", isPresented: $showEndGameAlert) {
            Button("Cancel", role: .cancel) { }
            Button("End Game", role: .destructive) { endGame() }
        } message: {
            Text("Mark this game as completed?")
        }
    }

    private var scoreboardSection: some View {
        HStack {
            VStack {
                Text(game.homeTeam?.abbreviation.isEmpty == false ? game.homeTeam!.abbreviation : game.homeTeam?.name ?? "Home")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text("\(game.homeScore)")
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                HStack(spacing: 16) {
                    Button { game.homeScore += 1 } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                    }
                    Button {
                        if game.homeScore > 0 { game.homeScore -= 1 }
                    } label: {
                        Image(systemName: "minus.circle")
                            .font(.title2)
                    }
                }
            }
            .frame(maxWidth: .infinity)

            VStack {
                Text("Set \(game.currentSet)")
                    .font(.headline)
                    .foregroundStyle(.secondary)
            }

            VStack {
                Text(game.opponent)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text("\(game.awayScore)")
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                HStack(spacing: 16) {
                    Button { game.awayScore += 1 } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                    }
                    Button {
                        if game.awayScore > 0 { game.awayScore -= 1 }
                    } label: {
                        Image(systemName: "minus.circle")
                            .font(.title2)
                    }
                }
            }
            .frame(maxWidth: .infinity)
        }
        .padding()
        .background(Color(.systemGroupedBackground))
    }

    private var playerSelector: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(players, id: \.id) { player in
                    Button {
                        selectedPlayer = player
                    } label: {
                        VStack(spacing: 2) {
                            Text("#\(player.jerseyNumber)")
                                .font(.headline)
                            Text(player.lastName)
                                .font(.caption2)
                                .lineLimit(1)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(selectedPlayer?.id == player.id ? Color.blue : Color(.systemGray5))
                        .foregroundStyle(selectedPlayer?.id == player.id ? .white : .primary)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
        }
    }

    private var statButtons: some View {
        ScrollView {
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                ForEach(StatType.allCases) { type in
                    Button {
                        recordStat(type)
                    } label: {
                        VStack(spacing: 6) {
                            Image(systemName: type.icon)
                                .font(.title2)
                            Text(type.label)
                                .font(.caption)
                                .fontWeight(.medium)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(type == .error ? Color.red.opacity(0.1) : Color.blue.opacity(0.1))
                        .foregroundStyle(type == .error ? .red : .blue)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .buttonStyle(.plain)
                    .disabled(selectedPlayer == nil)
                }
            }
            .padding()
        }
    }

    private func recordStat(_ type: StatType) {
        guard let player = selectedPlayer else { return }
        let entry = StatEntry(type: type, set: game.currentSet)
        entry.player = player
        entry.game = game
        modelContext.insert(entry)
    }

    private func endSet() {
        game.addSetScore(home: game.homeScore, away: game.awayScore)
        game.homeScore = 0
        game.awayScore = 0
        game.currentSet += 1
    }

    private func endGame() {
        if game.homeScore > 0 || game.awayScore > 0 {
            game.addSetScore(home: game.homeScore, away: game.awayScore)
        }
        // Calculate total sets won
        let sets = game.setScores
        let homeWins = sets.filter { $0.home > $0.away }.count
        let awayWins = sets.filter { $0.away > $0.home }.count
        game.homeScore = homeWins
        game.awayScore = awayWins
        game.isCompleted = true
    }
}
