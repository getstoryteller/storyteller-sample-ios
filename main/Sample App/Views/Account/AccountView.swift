import SwiftUI
import StorytellerSDK

struct AccountView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel: AccountViewModel

    init(dataService: DataGateway) {
        self._viewModel = StateObject(wrappedValue: AccountViewModel(dataService: dataService))
    }

    // This view demonstrates how to pass User Attributes to the Storyteller SDK
    // for the purposes of personalization and targeting of stories.
    // The corresponding code which interacts with the Storyteller SDK is
    // visible in the StorytellerService class.
    // There is more information available about this feature in our
    // documentation here https://www.getstoryteller.com/documentation/ios/custom-attributes
    
    // The code here also shows to enable and disable event tracking for
    // the Storyteller SDK. The corresponding code which interacts with the
    // Storyteller SDK is visible in the StorytellerService class.
    
    var body: some View {
        List {
            Section("Personalisation") {
                if !viewModel.favoriteTeams.isEmpty {
                    Picker("Favorite Teams", selection: $viewModel.favoriteTeam) {
                        ForEach(viewModel.favoriteTeams) { team in
                            Text(team.name).tag(team.value)
                        }
                    }.pickerStyle(NavigationLinkPickerStyle())
                }
                if !viewModel.languages.isEmpty {
                    Picker("Language", selection: $viewModel.language) {
                        ForEach(viewModel.languages) { language in
                            Text(language.name).tag(language.value)
                        }
                    }.pickerStyle(NavigationLinkPickerStyle())
                }
            }
            Section("Settings") {
                Picker("Allow Event Tracking", selection: $viewModel.allowEventTracking) {
                    Text("Yes").tag("yes")
                    Text("No").tag("no")
                }.pickerStyle(NavigationLinkPickerStyle())
                Button("Reset") {
                    viewModel.reset()
                    dismiss()
                }
                .tint(.secondary)
                Button("Log Out") {
                    viewModel.logout()
                    dismiss()
                }
                .tint(Color(.activeRed))
            }
        }
        .navigationTitle("Account")
        .navigationBarTitleDisplayMode(.inline)
    }
}
