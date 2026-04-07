import SwiftUI
import SwiftData

struct TeamsListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Team.name) private var teams: [Team]
    @State private var showingAddTeam = false

    var body: some View {
        NavigationStack {
            List {
                if teams.isEmpty {
                    ContentUnavailableView(
                        "No Teams",
                        systemImage: "person.3.fill",
                        description: Text("Add a team to get started.")
                    )
                }
                ForEach(teams, id: \.id) { team in
                    NavigationLink(destination: TeamDetailView(team: team)) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(team.name)
                                .font(.headline)
                            Text("\(team.players.count) players · \(team.record)")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.vertical, 4)
                    }
                }
                .onDelete(perform: deleteTeams)
            }
            .navigationTitle("Teams")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: { showingAddTeam = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddTeam) {
                AddTeamView()
            }
        }
    }

    private func deleteTeams(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(teams[index])
        }
    }
}
