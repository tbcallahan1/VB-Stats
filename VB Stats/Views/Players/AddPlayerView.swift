import SwiftUI
import SwiftData

struct AddPlayerView: View {
    let team: Team
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var jerseyNumber = ""
    @State private var position = ""

    private let positions = ["", "Setter", "Outside Hitter", "Middle Blocker", "Opposite", "Libero", "Defensive Specialist"]

    var body: some View {
        NavigationStack {
            Form {
                Section("Player Info") {
                    TextField("First Name", text: $firstName)
                    TextField("Last Name", text: $lastName)
                    TextField("Jersey Number", text: $jerseyNumber)
                        .keyboardType(.numberPad)
                }
                Section("Position") {
                    Picker("Position", selection: $position) {
                        ForEach(positions, id: \.self) { pos in
                            Text(pos.isEmpty ? "None" : pos).tag(pos)
                        }
                    }
                }
            }
            .navigationTitle("New Player")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let player = Player(
                            firstName: firstName,
                            lastName: lastName,
                            jerseyNumber: Int(jerseyNumber) ?? 0,
                            position: position
                        )
                        player.team = team
                        modelContext.insert(player)
                        dismiss()
                    }
                    .disabled(firstName.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }
}
