import SwiftUI

struct EditProfileView: View {
    let viewModel: ProfileViewModel

    @Environment(\.dismiss) private var dismiss
    @State private var name: String
    @State private var location: String
    @State private var bio: String
    @State private var interests: String

    private static let bioLimit = 500

    init(user: User, viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        _name = State(initialValue: user.name)
        _location = State(initialValue: user.location)
        _bio = State(initialValue: user.bio)
        _interests = State(initialValue: user.interests.joined(separator: ", "))
    }

    private var canSave: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            && bio.count <= Self.bioLimit
            && !viewModel.isSaving
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Name") {
                    TextField("Your name", text: $name)
                        .textInputAutocapitalization(.words)
                }

                Section("City") {
                    TextField("e.g. Surat, Gujarat", text: $location)
                        .textInputAutocapitalization(.words)
                }

                Section {
                    TextField("Tell people about yourself", text: $bio, axis: .vertical)
                        .lineLimit(3...8)
                } header: {
                    Text("About you")
                } footer: {
                    Text("\(bio.count)/\(Self.bioLimit)")
                        .foregroundColor(bio.count > Self.bioLimit ? .red : .secondary)
                }

                Section {
                    TextField("Hiking, Coffee, Travel", text: $interests)
                        .textInputAutocapitalization(.words)
                } header: {
                    Text("Interests")
                } footer: {
                    Text("Separate interests with commas (up to 20).")
                }

                if let saveError = viewModel.saveError {
                    Section {
                        Text(saveError).foregroundColor(.red)
                    }
                }
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    if viewModel.isSaving {
                        ProgressView()
                    } else {
                        Button("Save") {
                            Task {
                                if await viewModel.save(name: name, bio: bio, location: location, interestsText: interests) {
                                    dismiss()
                                }
                            }
                        }
                        .disabled(!canSave)
                    }
                }
            }
        }
    }
}
