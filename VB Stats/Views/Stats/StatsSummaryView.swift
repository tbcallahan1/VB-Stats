import SwiftUI
import SwiftData

struct StatsSummaryView: View {
    @Query(sort: \Team.name) private var teams: [Team]
    @State private var selectedTeam: Team?
    @State private var selectedStatType: StatType = .kill

    var body: some View {
        NavigationStack {
            VStack {
                if teams.isEmpty {
                    ContentUnavailableView(
                        "No Stats Yet",
                        systemImage: "chart.bar.fill",
                        description: Text("Add teams and play games to see stats.")
                    )
                } else {
                    Picker("Team", selection: $selectedTeam) {
                        Text("All Teams").tag(nil as Team?)
                        ForEach(teams, id: \.id) { team in
                            Text(team.name).tag(team as Team?)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)

                    Picker("Stat", selection: $selectedStatType) {
                        ForEach(StatType.allCases) { type in
                            Text(type.label).tag(type)
                        }
                    }
                    .pickerStyle(.menu)
                    .padding(.horizontal)

                    List {
                        ForEach(rankedPlayers, id: \.id) { player in
                            HStack {
                                Text("#\(player.jerseyNumber)")
                                    .font(.headline)
                                    .frame(width: 44)
                                VStack(alignment: .leading) {
                                    Text(player.fullName)
                                    if let teamName = player.team?.name {
                                        Text(teamName)
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }
                                }
                                Spacer()
                                Text("\(player.totalStat(selectedStatType))")
                                    .font(.title3)
                                    .fontWeight(.bold)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Stats")
        }
    }

    private var rankedPlayers: [Player] {
        let allPlayers: [Player]
        if let team = selectedTeam {
            allPlayers = team.players
        } else {
            allPlayers = teams.flatMap { $0.players }
        }
        return allPlayers
            .filter { $0.totalStat(selectedStatType) > 0 }
            .sorted { $0.totalStat(selectedStatType) > $1.totalStat(selectedStatType) }
    }
}
