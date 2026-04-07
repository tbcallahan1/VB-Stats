import SwiftUI
import SwiftData

@main
struct VBStatsApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Team.self, Player.self, Game.self, StatEntry.self])
    }
}
