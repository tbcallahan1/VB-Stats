import SwiftUI
import SwiftData

struct AddGameView: View {
    let team: Team
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var opponent = ""
    @State private var date = Date()

    var body: some View {
        NavigationStack {
            Form {
                Section("Game Info") {
                    TextField("Opponent", text: $opponent)
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                }
            }
            .navigationTitle("New Game")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let game = Game(opponent: opponent, date: date)
                        game.homeTeam = team
                        modelContext.insert(game)
                        dismiss()
                    }
                    .disabled(opponent.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }
}
