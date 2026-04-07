import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            TeamsListView()
                .tabItem {
                    Label("Teams", systemImage: "person.3.fill")
                }

            GamesListView()
                .tabItem {
                    Label("Games", systemImage: "sportscourt.fill")
                }

            StatsSummaryView()
                .tabItem {
                    Label("Stats", systemImage: "chart.bar.fill")
                }
        }
    }
}

#Preview {
    ContentView()
}
