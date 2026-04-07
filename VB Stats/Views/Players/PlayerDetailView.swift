import SwiftUI

struct PlayerDetailView: View {
    let player: Player

    var body: some View {
        List {
            Section("Info") {
                LabeledContent("Name", value: player.fullName)
                LabeledContent("Number", value: "#\(player.jerseyNumber)")
                if !player.position.isEmpty {
                    LabeledContent("Position", value: player.position)
                }
            }

            Section("Career Stats") {
                StatRow(label: "Kills", icon: "flame.fill", value: player.totalKills)
                StatRow(label: "Assists", icon: "hands.clap.fill", value: player.totalAssists)
                StatRow(label: "Blocks", icon: "hand.raised.fill", value: player.totalBlocks)
                StatRow(label: "Digs", icon: "arrow.down.to.line", value: player.totalDigs)
                StatRow(label: "Aces", icon: "star.fill", value: player.totalAces)
                StatRow(label: "Serve Receives", icon: "arrow.uturn.up", value: player.totalServeReceives)
                StatRow(label: "Errors", icon: "xmark.circle.fill", value: player.totalErrors, tint: .red)
            }

            if !player.stats.isEmpty {
                Section("Recent Activity") {
                    ForEach(player.stats.sorted(by: { $0.timestamp > $1.timestamp }).prefix(20), id: \.id) { stat in
                        HStack {
                            Image(systemName: stat.type.icon)
                                .foregroundStyle(.blue)
                            Text(stat.type.label)
                            Spacer()
                            Text("Set \(stat.set)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
        }
        .navigationTitle(player.displayName)
    }
}

struct StatRow: View {
    let label: String
    let icon: String
    let value: Int
    var tint: Color = .blue

    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundStyle(tint)
                .frame(width: 24)
            Text(label)
            Spacer()
            Text("\(value)")
                .fontWeight(.semibold)
        }
    }
}
